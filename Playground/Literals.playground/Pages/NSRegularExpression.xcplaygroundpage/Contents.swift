//: [Previous](@previous)

import Foundation

//func matchesInCapturingGroups(text: String, pattern: String) -> [String] {
//    var results = [String]()
//    
//    let textRange = NSMakeRange(0, text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//    
//    do {
//        let regex = try NSRegularExpression(pattern: pattern, options: [])
//        let matches = regex.matchesInString(text, options: NSMatchingOptions.ReportCompletion, range: textRange)
//        
//        for index in 1..<matches[0].numberOfRanges {
//            results.append((text as NSString).substringWithRange(matches[0].rangeAtIndex(index)))
//        }
//        return results
//    } catch {
//        return []
//    }
//}
//
//let pattern = "(\")(.+)(\")\\s*(\\{)"
//print(matchesInCapturingGroups("\"base\" {", pattern: pattern))

func matchesInCapturingGroups(_ text:String ,pattern:String)->[String]
{
//    var results = [String]()
    let textRange = NSRange.init(location: 0, length: text.lengthOfBytes(using: .utf8))
//    do {
        let regex = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: text, options: .reportCompletion, range: textRange)
        for index in 1..<matches[0].numberOfRanges {
//            //
            print("\((text as NSString).substring(with: matches[0].rangeAt(index)) )")
//            results.append((text as NSString).substring(with: matches[0].rangeAt(index)))
        }
//        return results
//    } catch
//    {
        return []
//    }
}
//let pattern = "(\")(.+)(\")\\s*(\\{)"  //print:["\"", "base", "\"", "{"]
//(-w+(sw+)*-)s
let pattern = "\\s([A-Z]{2,})\\s"

print(matchesInCapturingGroups("Shopping DDD List\r\r1. Cheese\r2. Biscuits\r3. _Sausages_\r4. *IMPORTANT* Cash for going out!\r5. -potatoes-\r6. A copy of iOS6 by tutorials\r7. ~An ew~ QQQ iPhone\r8. A present for mum", pattern: pattern))
//: [Next](@next)
