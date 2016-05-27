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