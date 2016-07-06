#存在多个project的workspace中引入cocoapods管理https://yq.aliyun.com/articles/8315
workspace 'SISpeciesNotes.xcworkspace'
project 'SISpeciesNotes.xcodeproj'

target 'SISpeciesNotes' do
    platform :ios, '8.0'
    use_frameworks!
    inhibit_all_warnings!
    project 'SISpeciesNotes.xcodeproj'
    
    pod 'RealmSwift'
    pod 'ObjectMapper', '= 1.1.5'
    
    pod 'Alamofire', '~> 3.0'
    #alamofire组件
    pod 'AlamofireImage', '~> 2.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 1.0'
    
    #
    pod 'SDWebImage', '~>3.7'
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
    
    #autolayout框架
    pod 'Masonry'  #OC
    pod 'SnapKit', '~> 0.20.0'  #swift
    pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    #------仿UIStackView的两个开源库，用户兼容9以下版本-----
    #OAStackView，基于OC的StackView库，支持iOS7+以上的系统。同时支持代码和IB视图。功能强大，无需质疑。
    #TZStackView，基于Swift的StackView库，同样支持iOS7+以上的系统，但是不支持storyboard。
    #pod "TZStackView", "1.1.2"
    
    
    #工具
    pod  'SwiftFilePath'
    
    #mustache模板引擎
    pod 'GRMustache.swift', '~> 1.0'
    
    #热修复/热更新库
    pod 'JSPatch'
    
    #响应式开发依赖库 https://realm.io/cn/news/slug-max-alexander-functional-reactive-rxswift/
    pod 'RxSwift', '~> 2.0.0'
    pod 'RxCocoa', '~> 2.0'
    
    #添加单元测试依赖库
    #介绍： https://realm.io/cn/news/tryswift-ash-furrow-artsy-testing-tour/
    #https://github.com/Quick/Quick/blob/master/Documentation/en-us/InstallingQuick.md#cocoapods
    #Specta让我们采用行为驱动开发(BDD)风格的语法来编写测试，相比于XCTest的语法，它更加易读。它还有一个强大的分组测试功能，在测试之前或之后运行一些代码块，这样的话，能够极大地减少重复代码。
    
#    Expecta是一个匹配器框架，我们可以在测试中使用它来创建断言。它的语法非常强大，与此同时，它比内建的XCAssert套件更加易读。例如
    def testing_pods
        pod 'Quick'         #Specta “可视化”测试
        pod 'Nimble'        # Expecta 匹配器框架
        pod 'RxBlocking', '~> 2.0'
#        pod 'RxTests',    '~> 2.0'  #失败，无法集成https://github.com/ReactiveX/RxSwift/issues/472
    end

    # Has its own copy of Quick,Nimble,RxBlocking
    # and has access to JSPatch via the SISpeciesNotes app
    # that hosts the test target
    target 'SISpeciesNotesTests' do
        inherit! :search_paths
        testing_pods
    end

    target 'SISpeciesNotesUITests' do
        inherit! :search_paths
        testing_pods
    end
end

target 'ScaryBugsMac' do
    platform :osx, '10.9'
    use_frameworks!
    project 'ScaryBugsMac/ScaryBugsMac.xcodeproj'
    pod 'EDStarRating'
#    pod 'SwiftWebSocket'
    pod 'CocoaAsyncSocket'
#    pod 'RealmSwift'
    pod 'FMDB'
    
    target 'ScaryBugsMacTests' do
        inherit! :search_paths
        pod 'EDStarRating'
    end
end

target 'mpv-examples' do
    platform :osx, '10.9'
    use_frameworks!
    project 'mpv-examples/mpv-examples.xcodeproj'
    pod 'FMDB'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts target.name
    end
end













