[@selector() in Swift?](http://stackoverflow.com/questions/24007650/selector-in-swift )
 There are a couple of extra caveats for the function references you pass to the #selector expression:
 
 Multiple functions with the same base name can be differentiated by their parameter labels using the aforementioned syntax for function references (e.g. insertSubview(_:, atIndex:) vs insertSubview(_:aboveSubview:)). But if a function has no parameters, the only way to disambiguate it is to use an as cast with the function's type signature (e.g. foo as () -> () vs foo(_:)).
 Swift doesn't know about the ObjC accessors for property getter/setter pairs. So, for example, given a var foo: Int, there isn't a func setFoo(_:) that you can construct a #selector from, even though there is a Selector(setFoo:).

[数组 ENUMERATE](http://swifter.tips/enumerate/)
 这里我们需要用到 *stop 这个停止标记的指针，并且直接设置它对应的值为 YES 来打断并跳出循环。而在 Swift 中，这个 API 的 *stop 被转换为了对应的 UnsafeMutablePointer<ObjCBool>。如果不明白 Swift 的指针的表示形式的话，一开始可能会被吓一跳，但是一旦当我们明白 Unsafe 开头的这些指针类型的用法之后，就会知道我们需要对应做的事情就是将这个指向 ObjCBool 的指针指向的内存的内容设置为 true 而已：
 
 let arr: NSArray = [1,2,3,4,5]
 var result = 0
 arr.enumerateObjectsUsingBlock { (num, idx, stop) -> Void in
 result += num as! Int
 if idx == 2 {
 stop.memory = true
 }
 }
 print(result)
 // 输出：6

#####APP涉及到的知识点：
 iCloud Document-Based App Overview
 Next let’s give an overview of what it takes to make an iCloud Document-Based App, and some design choices we’re going to make for PhotoKeeper along the way. We will cover five topics:
1. How it Works
2. Subclassing UIDocument
    2.1 `loadFromContents`:ofType:error: Think of this as “read the document”. You get an input class, and you have to decode it to your internal model.
    2.2 `contentsForType`:error: Think of this as “write the document”. You encode your internal model to an output class.
3. Input/Output Formats
    3.1 `NSData`. This represents a simple buffer of data, which is good when your document is just a single file.
    3.2 `NSFileWrapper`. This represents a directory of file packages, which the OS treats as a single file. This is good for when your document consists of multiple files that you want to be able to load independently.
 At first glance, it might seem that using NSData would make the most sense, since our document is just a simple photo.
4. Local vs. iCloud
5. Storage Philosophy


#####APP具体实现步骤:
To sum up what we discussed above, we will be doing the following for PhotoKeeper:
1. Choosing a Document-Based App as our storage method.
2. Creating a model class (a plain old NSObject that stores our large photo) that implements NSCoding.
3. Creating a metadata class (a plain old NSObject that stores our small thumbnail) that implements NSCoding.
4. Subclassing UIDocument. It will have a reference to the model and metadata classes.
5. Using NSFileWrapper for input/output. Our UIDocumentClass will encode both the model and metadata into separate files inside our NSFileWrapper directory.
6. Work both locally and for iCloud. We will start with local only and add iCloud support later in the series.
7. Add iCloud on/off toggle in Settings. All documents will be stored either locally or in iCloud.
