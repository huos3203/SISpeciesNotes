//: [Previous](@previous)

import Foundation

import XCPlayground


//文本排除区域：通过
XCPlaygroundPage.currentPage.liveView = ExclusionPath()

//日期戳
//let view = TimeIndicatorView.init(time: NSDate())

//XCPlaygroundPage.currentPage.liveView = view

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
    let timeIndicatorView = TimeIndicatorView.init(time: NSDate())
    var textStorage:SyntaxHighlightTextStorage! = nil
    var textView:UITextView! = nil
    
    var keyboardSize:CGSize!
    
    override func viewDidLoad() {
        //
        createTextView()
        
        //收到用于指定本类接收字体设定变化的通知后，调用preferredContentSizeChanged:方法
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredContentSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        //编辑长文本的时候键盘挡住了下半部分文本的问题
        textView.scrollEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    //创建文本区域
    func createTextView() {
        //
        // 1. Create the text storage that backs the editor
        let attrs = [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attrString = NSAttributedString(string: "",attributes: attrs)
        textStorage = SyntaxHighlightTextStorage()
        textStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        
        // 3. Create a text container
        //文本容器的宽度会自动匹配视图的宽度，但是它的高度是无限高的——或者说无限接近于CGFloat.max，它的值可以是无限大。
        let containerSize = CGSizeMake(newTextViewRect.size.width, CGFloat.max)
        let container = NSTextContainer.init(size: containerSize)
        container.widthTracksTextView = true
        //
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        textView = UITextView.init(frame: newTextViewRect, textContainer: container)
        textView.delegate = self
        view.addSubview(textView)
    }
    
    func preferredContentSizeChanged(notification:NSNotification) {
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
        //将_timeView放在右上角。
        timeIndicatorView.frame = CGRectOffset(timeIndicatorView.frame,
                                               view.frame.size.width - timeIndicatorView.frame.size.width, 0.0)
    }
}

//键盘遮挡问题
extension NoteEditorViewController{

    //键盘问题
    func keyboardDidShow(notification:NSNotification) {
        //
        let userInfo = notification.userInfo
        keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        updateTextViewSize()
    }
    
    func keyboardDidHide(notification:NSNotification) {
        //
        keyboardSize = CGSize(width: 0,height: 0)
        updateTextViewSize()
    }
    
    //键盘显示或隐藏时,缩小文本视图的高度以适应键盘的显示状态
    func updateTextViewSize() {
        //计算文本视图尺寸的时候你要考虑到屏幕的方向
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        //因为屏幕方向变化后,UIView的宽高属性会对换,但是键盘的宽高属性却不会
        let keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? keyboardSize.width:keyboardSize.height
        
        textView.frame = CGRectMake(0,0,view.frame.size.width,view.frame.size.height - keyboardHeight)
    }
}

class SyntaxHighlightTextStorage: NSTextStorage {
    //文本存储器子类必须提供它自己的“数据持久化层”。
    var backingStore = NSMutableAttributedString()
    var replacements = [String:[String:AnyObject]]()
    
    override var string: String{
        return backingStore.string
    }
}

//把任务代理给后台存储,调用beginEditing / edited / endEditing这些方法来完成一些编辑任务.
//这样做是为了在编辑发生后让文本存储器的类通知相关的布局管理器。
extension SyntaxHighlightTextStorage{

    /**
     可能注意到了你需要很多代码来创建文本存储器的类的子类。既然NSTextStorage是一个类族的公共接口，那就不能只是通过创建子类及重载几个方法来扩张它的功能。有些特定需求你是要自己实现的，比方attributedString数据的后台存储。
     类族就是抽象工厂模式的实现，无需指定具体的类就可以为创建一族相关或从属的对象提供一个公共接口。一些我们很熟悉的类比方NSArray和NSNumber事实上是一族类的公共接口。
     */
    
    override func attributesAtIndex(location:Int,effectiveRange:NSRangePointer) -> [String : AnyObject] {
        //
        return backingStore.attributesAtIndex(location, effectiveRange: effectiveRange)
    }

    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        //
        print("replaceCharactersInRange:\(NSStringFromRange(range)) withString:\(str)")
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString: str)
        //注意的是通过characters属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。作为佐证，当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16.Count
        edited([.EditedAttributes,.EditedCharacters], range: range, changeInLength: str.utf16.count - range.length)
        endEditing()
        
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        //
        print("setAttributes:\(attrs) range:\(NSStringFromRange(range))")
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }

}

//动态格式（Dynamic formatting）:
//将对你的自定义文本存储器进行修改以将＊星号符之间的文本＊变为黑体：
extension SyntaxHighlightTextStorage{

    //将文本的变化通知给布局管理器。它也为文本编辑之后的处理提供便利。
    override func processEditing() {
        //
        performReplacementsForRange(editedRange)
        super.processEditing()
    }
    
    //
    func performReplacementsForRange(changedRange:NSRange){
        //backingStore.string必须转为NSString类型，这样才能使用lineRangeForRange方法
        var extendedRange = NSUnionRange(changedRange, (backingStore.string as NSString).lineRangeForRange(NSMakeRange(changedRange.location, 0)))

        extendedRange = NSUnionRange(changedRange, (backingStore.string as NSString).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(extendedRange)
    }
    
    func applyStylesToRange(searchRange:NSRange) {
        
        // 1. create some fonts
        let normalAttrs = [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        // iterate over each replacement
        for regexStr in replacements.keys {
            //
            // 2. match items surrounded by asterisks
            //创建一个正则表达式来定位星号符包围的文本。
            //例如，在字符串“iOS 7 is *awesome*”中，存储在regExStr中的正则表达式将会匹配并返回文本“*awesome*”。
            //let regexStr = "(w+(sw+))s"
            let regex = try! NSRegularExpression(pattern: regexStr, options: .CaseInsensitive)
            
            let textAttributes = replacements[regexStr]
            
            // 3. iterate over each match, making the text bold
            //对正则表达式匹配到并返回的文本进行枚举并添加粗体属性。
            regex.enumerateMatchesInString(backingStore.string, options: .Anchored, range: searchRange) { (match, flags, stop) in
                // apply the style
                let matchRange = match?.rangeAtIndex(1)
                self.addAttributes(textAttributes!, range: matchRange!)
                
                // 4. reset the style to the original
                //将后一个星号符之后的文本都重置为“常规”样式。以保证添加在后一个星号符之后的文本不被粗体风格所影响。
                if (NSMaxRange(matchRange!)+1 < self.length){
                    self.addAttributes(normalAttrs, range: NSMakeRange(NSMaxRange(matchRange!)+1, 1))
                }
            }

        }
    }
}

//进一步添加样式
//为限定文本添加风格的基本原则很简单：
//使用正则表达式来寻找和替换限定字符，然后用applyStylesToRange来设置想要的文本样式即可。
extension SyntaxHighlightTextStorage{

    func createHighlightPatterns()  {
        
        //使用Zapfino字体来创建了“script”风格
        //Font descriptors会决定当前正文的首选字体，以保证script不会影响到用户的字体大小设置。字体描述器（Font descriptors）是一种描述性语言，它使你可以通过设置属性来修改字体，或者无需初始化UIFont实例便可获取字体规格的细节。
        //字体描述器能使你无需对字体手动编码来设置字体和样式。
        let scriptFontDescriptor = UIFontDescriptor.init(fontAttributes: [UIFontDescriptorFamilyAttribute:"Zapfino"])
        
        
        // 1. base our script font on the preferred body font size
        //为每种匹配的字体样式构造各个属性
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        
        let bodyFontSize = bodyFontDescriptor.fontAttributes()[UIFontDescriptorSizeAttribute]
        
        let scriptFont = UIFont.init(descriptor: scriptFontDescriptor, size: CGFloat((bodyFontSize?.floatValue)!))
        
        // 2. create the attributes
        let boldAttributes = createAttributesForFontStyle(UIFontTextStyleBody, trait: .TraitBold)
        
        let italicAttributes = createAttributesForFontStyle(UIFontTextStyleBody, trait: .TraitItalic)
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName:NSNumber.init(int: 1)]
        let scriptAttributes = [NSFontAttributeName:scriptFont]
        let redTextAttributes = [NSForegroundColorAttributeName:UIColor.redColor()]

        // construct a dictionary of replacements based on regexes
        //创建一个NSDictionary并将正则表达式映射到上面声明的属性上
        //1. 把波浪线(~)之间的文本变为艺术字体
        //2. 把下划线(_)之间的文本变为斜体
        //3. 为破折号(-)之间的文本添加删除线
        //4. 把字母全部大写的单词变为红色
        replacements = [
            "(*w+(sw+)**)s" : boldAttributes,
            "(w+(sw+)*_)s" : italicAttributes,
            "([0-9]+.)s" : boldAttributes,
            "(-w+(sw+)*–)s" : strikeThroughAttributes,
            "(~w+(sw+)*~)s" : scriptAttributes,
            "s([A-Z]{2,})s" : redTextAttributes]
    }
    
    //将提供的字体样式作用到正文字体上:
    //它给fontWithDescriptor:size: 提供的size值为0，这样做会迫使UIFont返回用户设置的字体大小。
    func createAttributesForFontStyle(style:String,trait:UIFontDescriptorSymbolicTraits) -> [String:AnyObject] {
        //
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let descriptorWithTraint = fontDescriptor.fontDescriptorWithSymbolicTraits(trait)
        let font = UIFont.init(descriptor: descriptorWithTraint, size: 0.0)
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
        let bodyFont = [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        addAttributes(bodyFont, range: NSMakeRange(0, length))
        // re-apply the regex matches
        applyStylesToRange(NSMakeRange(0,length))
    }
}


//: [Next](@next)
