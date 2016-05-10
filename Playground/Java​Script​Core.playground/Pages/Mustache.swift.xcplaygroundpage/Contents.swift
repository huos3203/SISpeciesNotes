//: [Previous](@previous)

import Foundation

import Mustache

// Renders "Hello Arthur"
func helloMustache(){
    let template2 = try! Template(string: "Hello {{ name }}")
    let rendering2 = try! template2.render(Box(["name": "Arthur"]))
    print(rendering2)
}

// Load the `document.mustache` resource of the main bundle
func LoadDocument(){
    let template = try! Template.init(URL:[#FileReference(fileReferenceLiteral: "Document")#])
    
    // Let template format dates with `{{format(...)}}`
    let datefarmat = NSDateFormatter()
    datefarmat.dateStyle = .MediumStyle
    //向JS中注入Dateformat方法
    template.registerInBaseContext("format", Box(datefarmat))
    
    // The rendered data
    let data = ["name":"Arthur",
                "date":NSDate(),
                "real_date":NSDate().dateByAddingTimeInterval(60*60*24*3),
                "late":true]
    
    // The rendering: "Hello Arthur..."
    let rendering = try! template.render(Box(data))
    print(rendering)
}





//: [Next](@next)
