//
//  URLSessionTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/18.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
/*
    NSURLConnection
    NSURLSession ,  NSURLSessionConfiguration  , NSURLSessionTask
 - NSURLSession—A session object.
 - NSURLSessionConfiguration—A configuration object used when initializing the session.
 - NSURLSessionTask—The base class for tasks within a session.
    - NSURLSessionDataTask—A task for retrieving the contents of a URL as an NSData object
        - NSURLSessionUploadTask—A task for uploading a file, then retrieving the contents of a URL as an NSData object
    - NSURLSessionDownloadTask—A task for retrieving the contents of a URL as a temporary file on disk
*/
class URLSessionTest: XCTestCase {
    
    var baidu:URL!
    var request:URLRequest!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //传统方法NSURLConnection
    func testConnection(){
        //访问网络两个必不可缺少的
        baidu = URL(string:"https://www.baidu.com")
        request = URLRequest.init(url: baidu!)
        print("请求路径地址：\(request.url?.absoluteString)")
        let expecttaion = expectation(description: "timeout....")
        //一个URL ,一个request
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
            (response, data, error) in
            
            expecttaion.fulfill()
            print("响应的服务器地址：\(response?.url?.absoluteString)")
            XCTAssertNotNil(data,"数据返回为nil")
            XCTAssertNil(error, (error?.localizedDescription)!)
            //处理响应信息
            //response.
            //解析Data
            guard let dataFormatString = String(data: data!, encoding:String.Encoding.utf8)
            else
            {
                print("百度网页源码:\(data!)")
                return
            }
            print("百度网页源码:\(dataFormatString)")
        }
        
        waitForExpectations(timeout: 10){ error in
            //
            print("错误信息:\(error?.localizedDescription)")
        }
    }
    
    //使用NSURLSession访问服务
    func testSessionDataTask(){
        //访问网络两个必不可缺少的
        baidu = URL(string:"https://www.baidu.com")
        request = URLRequest.init(url: baidu!)
        let expectation = self.expectation(description: "session timeout ...")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            //
            XCTAssertNil(error,"存在错误...\(error?.localizedDescription)")
            //解析data转换为易读的String类型
            if data != nil
            {
                let dataFormatToString = String(data: data! , encoding:String.Encoding.utf8)
                print("session 解析出的URL数据："+dataFormatToString!)
            }
            
            expectation.fulfill()
        }) 
        task.resume()
        //(task.originalRequest?.timeoutInterval)!
        waitForExpectations(timeout: (task.originalRequest?.timeoutInterval)!) { (error) in
            //错误处理
        }
    }
    
    //测试NSURLSession上传功能
    //由于NSURLProtocol的局限性，OHHTTPStubs没法用来测试background sessions和模拟数据上传。
    func testSessionUploadTask() {
        //一个request，一个要上传的 NSData 对象或者是一个本地文件的路径对应的 NSURL
        let URL = Foundation.URL(string: "http://example.om/upload")
        let request = URLRequest(url: URL!)
        let data = Data()
        let expectation = self.expectation(description: "上传文件超时...")
        let uploadTask = URLSession.shared.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
            //解析上传后，返回的信息
            //parsedata()
            expectation.fulfill()
        })
        uploadTask.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }

    //测试NSURLSession下载功能
    //Data task 和 upload task 会在任务完成时一次性返回，但是 Download task 是将数据一点点地写入本地的临时文件。所以在 completionHandler 这个 block 里，我们需要把文件从一个临时地址移动到一个永久的地址保存起来：
    func testSessionDownloadTask(){
        
        //一个request ,一个提供下载的文件路径
        let URL = Foundation.URL(string: "https://github.com/huos3203/SISpeciesNotes/blob/master/readme.md")
        let request = URLRequest(url: URL!)
        let expectation = self.expectation(description: "下载文件超时...")
        let downLoadTast = URLSession.shared.downloadTask(with: request, completionHandler: { (location, response, error) in
        
            XCTAssertNil(error,"\(error?.localizedDescription)")
            //指定一个永久地址
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let filePath = ((documentsPath)! + ("/"+response!.url!.lastPathComponent))
            //判断路径文件是否已经存在,不能使用newFileLocation.absoluteString：因为其带有file://协议前缀
            //所以应使用documentsPath+文件名来作为文件路径
            var randomFlag = ""
            if(FileManager.default.fileExists(atPath: filePath))
            {
                //随机数来指定不同的文件名，避免文件路径重名
                randomFlag = "\(arc4random() % 100)"
            }
            
            //文件路径转为NSURL，执行迁移文件
            let documentsDirectoryURL = Foundation.URL.init(fileURLWithPath: documentsPath!)
            let newFileLocation = documentsDirectoryURL.appendingPathComponent("\(randomFlag)"+(response?.url?.lastPathComponent)!)
            
            do{
                try FileManager.default.copyItem(at: location!, to: newFileLocation)
                print("文件永久存放路径：\(newFileLocation.absoluteString)")
            }catch let error as NSError
            {
                print("错误原因:\(error.localizedFailureReason)")
            }
            
            expectation.fulfill()
        }) 
        downLoadTast.resume()
        waitForExpectations(timeout: 50, handler: nil)
    }
    
    //测试NSURLSessionConfiguration工厂模式
    //从指定可用网络，到 cookie，安全性，缓存策略，再到使用自定义协议，启动事件的设置，以及用于移动设备优化的几个新属性，几乎可以找到任何你想要进行配置的选项
    //NSURLSession 在初始化时会把配置它的 NSURLSessionConfiguration 对象进行一次 copy，并保存到自己的 configuration 属性中，而且这个属性是只读的。因此之后再修改最初配置 session 的那个 configuration 对象对于 session 是没有影响的。也就是说，configuration 只在初始化时被读取一次，之后都是不会变化的。
    
    func testDefaultSessionConfiguration(){
        //返回一个标准的 configuration，这个配置实际上与 NSURLConnection 的网络堆栈（networking stack）是一样的，具有相同的共享 NSHTTPCookieStorage，共享 NSURLCache 和共享 NSURLCredentialStorage
    
        let configutation = URLSessionConfiguration.default
        let session = URLSession(configuration: configutation)
        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        let defaultTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            //数据解析
            
        }) 
        defaultTask.resume()
        
    }
    
    func testEphemeralSessionConfiguration() {
        //返回一个预设配置，这个配置中不会对缓存，Cookie 和证书进行持久性的存储。这对于实现像秘密浏览这种功能来说是很理想的。
    }
    
    func testBackgroundSessionConfiguration() {
        //它会创建一个后台 session。后台 session 不同于常规的，普通的 session，它甚至可以在应用程序挂起，退出或者崩溃的情况下运行上传和下载任务。初始化时指定的标识符，被用于向任何可能在进程外恢复后台传输的守护进程（daemon）提供上下文。
    }
}
