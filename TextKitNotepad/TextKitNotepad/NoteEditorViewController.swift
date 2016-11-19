//
//  ViewController.swift
//  TextKitNotepad
//
//  Created by pengyucheng on 16/5/4.
//  Copyright © 2016年 recomend. All rights reserved.
//

//==================================================================
//TextKit

//四大控件：
/**
 *  @author shuguang, 16-05-08 17:05:47
 *
 *
 1. NSTextStorage: 以attributedString的方式存储所要处理的文本并且将文本内容的任何变化都通知给布局管理器。可以自定义NSTextStorage的子类，当文本发生变化时，动态地对文本属性做出相应改变。
 
 2. NSLayoutManager: 获取存储的文本并经过修饰处理再显示在屏幕上；在App中扮演着布局“引擎”的角色。
 
 3. NSTextContainer: 描述了所要处理的文本在屏幕上的位置信息。每一个文本容器都有一个关联的UITextView. 可以创建 NSTextContainer的子类来定义一个复杂的形状，然后在这个形状内处理文本。
 
 */
import UIKit

class NoteEditorViewController: UIViewController,UITextViewDelegate {
    //
    var timeIndicatorView:TimeIndicatorView!
    var textStorage:SyntaxHighlightTextStorage! = nil
    var textView:UITextView! = nil
    
    var keyboardSize:CGSize!
    
    var note:NoteModel!
    
    override func viewDidLoad() {
        //
        //字体变化通知:调用preferredContentSizeChanged:方法
        NotificationCenter.default.addObserver(self, selector: #selector(NoteEditorViewController.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        //编辑长文本的时候键盘挡住了下半部分文本的问题
        NotificationCenter.default.addObserver(self, selector: #selector(NoteEditorViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NoteEditorViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        createTextView()
        //时间戳
        timeIndicatorView = TimeIndicatorView.init(time: note.timetamp)
        view.addSubview(timeIndicatorView)
    }
    
    //创建文本区域
    func createTextView()
    {
        //
        // 1. Create the text storage that backs the editor
        let attrs = [NSFontAttributeName:UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        let attrString = NSAttributedString(string: note.contents,attributes: attrs)
        textStorage = SyntaxHighlightTextStorage()
        textStorage.append(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        
        // 3. Create a text container
        //文本容器的宽度会自动匹配视图的宽度，但是它的高度是无限高的——或者说无限接近于CGFloat.max，它的值可以是无限大。
        let containerSize = CGSize.init(width: newTextViewRect.size.width,
                                        height: CGFloat.greatestFiniteMagnitude)
        
        let container = NSTextContainer.init(size: containerSize)
        //A Boolean that controls whether the receiver adjusts the width of its bounding rectangle when its text view is resized.
        container.widthTracksTextView = true
        //
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        textView = UITextView.init(frame: newTextViewRect, textContainer: container)
        textView.isScrollEnabled = true
        textView.delegate = self
        view.addSubview(textView)
    }
    
    //字体变化通知时调用
    func preferredContentSizeChanged(_ notification:NSNotification)
    {
        //收到用于指定本类接收字体设定变化的通知后
        textStorage.update()
        timeIndicatorView.updateSize()
    }
    
    //视图的控件调用viewDidLayoutSubviews对子视图进行布局时，TimeIndicatorView作为子控件也需要有相应的变化。
    override func viewDidLayoutSubviews() {
        //
        updateTimeIndicatorFrame()
    }
    
    func updateTimeIndicatorFrame() {
        //第一调用updateSize来设定_timeView的尺寸。
        timeIndicatorView.updateSize()
        //通过偏移frame参数，将timeIndicatorView放在右上角。
        timeIndicatorView.frame = timeIndicatorView.frame.offsetBy(dx:textView.frame.width - timeIndicatorView.frame.width, dy: 0.0)
        
        let exclusionPath = timeIndicatorView.curvePathWithOrigin(origin: timeIndicatorView.center)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        note.contents = textView.text
    }
}

//键盘遮挡问题
extension NoteEditorViewController
{
    func keyboardDidShow(_ notification:NSNotification) {
        //
        let userInfo = notification.userInfo
        keyboardSize = (userInfo![UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
        updateTextViewSize()
    }
    
    func keyboardDidHide(_ notification:NSNotification) {
        //
        keyboardSize = CGSize(width: 0,height: 0)
        updateTextViewSize()
    }
    
    //键盘显示或隐藏时,缩小文本视图的高度以适应键盘的显示状态
    func updateTextViewSize() {
        //计算文本视图尺寸的时候你要考虑到屏幕的方向
        let orientation = UIApplication.shared.statusBarOrientation
        //因为屏幕方向变化后,UIView的宽高属性会对换,但是键盘的宽高属性却不会
        let keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? keyboardSize.width:keyboardSize.height
        
        textView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - keyboardHeight)
    }
}

class SyntaxHighlightTextStorage: NSTextStorage
{
    //文本存储器子类必须提供它自己的“数据持久化层”。
    var backingStore = NSMutableAttributedString()
    var replacements = [String:[String:AnyObject]]()
    
    override init() {
        super.init()
        createHighlightPatterns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var string: String
    {
        return backingStore.string
    }
}

//把任务代理给后台存储,调用beginEditing / edited / endEditing这些方法来完成一些编辑任务.
//这样做是为了在编辑发生后让文本存储器的类通知相关的布局管理器。
extension SyntaxHighlightTextStorage{
    
    //Sends out -textStorage:willProcessEditing, fixes the attributes, sends out -textStorage:didProcessEditing, and notifies the layout managers of change with the -processEditingForTextStorage:edited:range:changeInLength:invalidatedRange: method.  Invoked from -edited:range:changeInLength: or -endEditing.
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any]
    {
        //
        if range == nil {
            return [:]
        }
//        print("backingStore:location\(location),effectiveRange:\(range!)")
         return backingStore.attributes(at: location, effectiveRange: range!)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String)
    {
        //
        print("replaceCharactersInRange:\(NSStringFromRange(range)) withString:\(str)")
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedAttributes,.editedCharacters],
                        range: range,
               changeInLength: str.utf16.count - range.length)
        
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange)
    {
        //Sets the attributes for the characters in the specified range to the specified attributes.
        print("setAttributes:\(attrs!) range:\(NSStringFromRange(range))")
        beginEditing()
        backingStore.setAttributes(attrs!, range: range)
        edited(.editedAttributes,
                        range: range,
               changeInLength: 0)
        
        endEditing()
    }
    
}

//动态格式（Dynamic formatting）:
//更新文本存储器的存储的文本样式，并通知布局管理器更新视图中的文本显示
extension SyntaxHighlightTextStorage{
    
    //将文本的变化通知给布局管理器。
    override func processEditing() {
        //更新文本存储器的存储的文本样式，editedRange：The range for pending changes
        performReplacementsForRange(editedRange)
        print("processEditing 通知布局管理器\(editedRange)")
        //通知布局管理器 notifies the layout managers of change
        super.processEditing()
    }
    
    //在指定的区域中进行替换
    func performReplacementsForRange(_ changedRange:NSRange){
        let locationRange = NSMakeRange(changedRange.location, 0)
        let range1 = (backingStore.string as NSString).lineRange(for: locationRange)
        //扩展范围
        var extendedRange = NSUnionRange(changedRange, range1)
        let maxRange = NSMakeRange(NSMaxRange(changedRange), 0)
        let range2 = (backingStore.string as NSString).lineRange(for: maxRange)
        extendedRange = NSUnionRange(changedRange, range2)
        print("在指定的区域中进行替换:\(extendedRange)")
        applyStylesToRange(searchRange: extendedRange)
    }
    
    func applyStylesToRange(searchRange:NSRange) {
        
        // 1. create some fonts
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        let normalAttrs = [NSFontAttributeName:font]
        // iterate over each replacement
        for regexStr in replacements.keys
        {
            // 2. match items surrounded by asterisks
            let regex:NSRegularExpression!
            do {
//                print("正则：\(regexStr)")
                regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
            }
            catch
            {
                print("----")
                continue
            }
            
            //获取对应正则的字体样式
            let textAttributes = replacements[regexStr]
            // 3. iterate over each match, making the text bold
            //使匹配到的所有字体样式生效
            regex!.enumerateMatches(in: backingStore.string, options: .init(rawValue: 0), range: searchRange)
            { (match, flags, stop) in
                // apply the style
                let matchRange = match?.rangeAt(1)
                let replaceText = (backingStore.string as NSString).substring(with: matchRange!)
                print("更新样式的内容：\(replaceText)")
                //重载的方法
                self.addAttributes(textAttributes!, range: matchRange!)
                // 4. reset the style to the original
                //将未匹配到的文本重置为“常规”样式。
                if (NSMaxRange(matchRange!)+1 < self.length)
                {
                    self.addAttributes(normalAttrs, range: NSMakeRange(NSMaxRange(matchRange!)+1, 1))
                }
            }
            
        }
    }
}

//为限定文本添加风格的基本原则很简单：
//使用正则表达式来寻找和替换限定字符，然后用applyStylesToRange来设置想要的文本样式即可。
extension SyntaxHighlightTextStorage{
    
    func createHighlightPatterns()  {
        
        //使用Zapfino字体来创建了“script”风格，字体描述器（Font descriptors）是一种描述性语言
        let scriptFontDescriptor = UIFontDescriptor.init(fontAttributes: [UIFontDescriptorFamilyAttribute:"Zapfino"])
        // 1. base our script font on the preferred body font size
        //保证script不会影响到用户的字体大小设置
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        let bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute]
        //“script”风格的Zapfino字体
        let scriptFont = UIFont.init(descriptor: scriptFontDescriptor,
                                     size: CGFloat(((bodyFontSize as AnyObject).floatValue)!))
        
        // 2. create the attributes
        //----为每种匹配的字体样式构造各个属性====
        let scriptAttributes = [NSFontAttributeName:scriptFont]
        
        let boldAttributes = createAttributesForFontStyle(style: UIFontTextStyle.body.rawValue,
                                                          trait: .traitBold)
        
        let italicAttributes = createAttributesForFontStyle(style: UIFontTextStyle.body.rawValue,
                                                            trait: .traitItalic)
        
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName:NSNumber.init(value: 1)]
        let redTextAttributes = [NSForegroundColorAttributeName:UIColor.red]
        //---- ------------
        // construct a dictionary of replacements based on regexes
        //创建一个NSDictionary并将正则表达式映射到上面声明的属性上
        replacements = [
            "(\\*\\w+(\\s\\w+)*\\*)\\s" : boldAttributes,
            "(_\\w+(\\s\\w+)*_)\\s" : italicAttributes,          //下划线(_)之间的文本变为斜体
            "([0-9]+.)\\s" : boldAttributes,
            "(-\\w+(\\s\\w+)*-)\\s" : strikeThroughAttributes,  //破折号(-)之间的文本添加删除线
            "(~\\w+(sw+)*~)\\s" : scriptAttributes,         //波浪线(~)之间的文本变为艺术字体
            "\\s([A-Z]{2,})\\s" : redTextAttributes]        //字母全部大写的单词变为红色
    }
    
    //将提供的字体样式作用到正文字体上:
    func createAttributesForFontStyle(style:String,trait:UIFontDescriptorSymbolicTraits) -> [String:AnyObject]
    {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        let descriptorWithTraint = fontDescriptor.withSymbolicTraits(trait)
        //size值为0，会迫使UIFont返回用户设置的字体大小。
        let font = UIFont.init(descriptor: descriptorWithTraint!, size: 0.0)
        return [NSFontAttributeName:font]
    }
}

//重做动态样式
//更新和各种正则表达式相匹配的字体,为整个文本字符串添加正文的字体样式,然后重新添加高亮样式。
extension SyntaxHighlightTextStorage{
    
    // update the highlight patterns
    func update() {
        // update the highlight patterns
        createHighlightPatterns()
        
        // change the 'global' font
        let bodyFont = [NSFontAttributeName:UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        addAttributes(bodyFont, range: NSMakeRange(0, length))
        // re-apply the regex matches
        applyStylesToRange(searchRange: NSMakeRange(0,length))
    }
}

