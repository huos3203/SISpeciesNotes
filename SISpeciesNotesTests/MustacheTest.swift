//
//  MustacheTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/5/10.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
import Mustache

class MustacheTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        DefaultConfiguration = Configuration()
    }
    
    func testDemo() {
        let templateString = "Hello {{name}}\n" +
            "Your luggage will arrive on {{format(date)}}.\n" +
            "{{#late}}\n" +
            "Well, on {{format(real_date)}} due to Martian attack.\n" +
        "{{/late}}"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let template = try! Template(string: templateString)
        template.registerInBaseContext("format", Box(dateFormatter))
        
        let data = [
            "name": "Arthur",
            "date": NSDate(),
            "real_date": NSDate().dateByAddingTimeInterval(60*60*24*3),
            "late": true
        ]
        let rendering = try! template.render(Box(data))
        XCTAssert(rendering.characters.count > 0)
    }

    //MARK: - 加载文档，填充文档内容提供的模板
    func testReadmeExample1(){
        
        let testBundle = NSBundle(forClass:self.dynamicType)
        let template = try! Template(named: "ReadMeExample1",bundle: testBundle)
        let data = [
            "name": "Chris",
            "value": 10000,
            "taxed_value": 10000 - (10000 * 0.4),
            "in_ca": true]
        let rendering = try! template.render(Box(data))
        
        XCTAssertEqual(rendering, "Hello Chris\nYou have just won 10000 dollars!\n\nWell, 6000.0 dollars, after taxes.\n")
    }
    
    //MARK: - 自定义pluralize过滤器:{{# pluralize(count) }}...{{/ }}，来判断 cat or cats
    func testReadmeExample2() {
        // Define the `pluralize` filter.
        //
        // {{# pluralize(count) }}...{{/ }} renders the plural form of the
        // section content if the `count` argument is greater than 1.
        
        let pluralizeFilter = Filter { (count: Int?, info: RenderingInfo) -> Rendering in
            // Pluralize the inner content of the section tag:
            var string = info.tag.innerTemplateString
            if count > 1 {
                string += "s"  // naive
            }
            return Rendering(string)
        }
        // Register the pluralize filter for all Mustache renderings:
        Mustache.DefaultConfiguration.registerInBaseContext("pluralize", Box(pluralizeFilter))
        
        // I have 3 cats.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let template = try! Template(named: "ReadMeExample2", bundle: testBundle)
        let data = ["cats": ["Kitty", "Pussy", "Melba"]]
        let rendering = try! template.render(Box(data))
        XCTAssertEqual(rendering, "I have 3 cats.")
    }
    
    //MARK: - 通过Model对象实现MustacheBoxable代理，
    //声明MustacheBox类型的计算属性，完成存储属性与模板中的{{name}}格式匹配
    func testReadmeExample3() {
        // TODO: update example from README.md
        //
        // Allow Mustache engine to consume User values.
        struct User : MustacheBoxable {
            let name: String
            var mustacheBox: MustacheBox {
                // Return a Box that wraps our user, and knows how to extract
                // the `name` key of our user:
                return MustacheBox(value: self, keyedSubscript: { (key: String) in
                    switch key {
                    case "name":
                        return Box(self.name)
                    default:
                        return Box()
                    }
                })
            }
        }
        
        let user = User(name: "Arthur")
        let template = try! Template(string: "Hello {{name}}!")
        let rendering = try! template.render(Box(user))
        XCTAssertEqual(rendering, "Hello Arthur!")
    }
    
    func testReadMeExampleNSFormatter1() {
        let percentFormatter = NSNumberFormatter()
        percentFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        percentFormatter.numberStyle = .PercentStyle
        
        let template = try! Template(string: "{{ percent(x) }}")
        template.registerInBaseContext("percent", Box(percentFormatter))
        
        let data = ["x": 0.5]
        let rendering = try! template.render(Box(data))
        XCTAssertEqual(rendering, "50%")
    }
    
    func testReadMeExampleNSFormatter2() {
        let percentFormatter = NSNumberFormatter()
        percentFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        percentFormatter.numberStyle = .PercentStyle
        
        let template = try! Template(string: "{{# percent }}{{ x }}{{/ }}")
        template.registerInBaseContext("percent", Box(percentFormatter))
        
        let data = ["x": 0.5]
        let rendering = try! template.render(Box(data))
        XCTAssertEqual(rendering, "50%")
    }

}
