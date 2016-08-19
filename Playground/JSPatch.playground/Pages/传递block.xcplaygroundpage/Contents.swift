//: [Previous](@previous)

import Foundation
//import JSPatch
import Pods_SISpeciesNotes

typealias myFunctionDefAlias = (@convention(block) (String,Bool)->())

@objc(JPObject)
class JPObject:NSObject {
    //
//    var callback:(String,Bool)->() = {_,_ in }
    
    dynamic class func request(callback:myFunctionDefAlias){
        callback("I'm content", true)
    }
}

JPEngine.startEngine()
let script = try! String.init(contentsOfURL: [#FileReference(fileReferenceLiteral: "content.js")#])
//执行JS
JPEngine.evaluateScript(script)




//: [Next](@next)
