#存在多个project的workspace中引入cocoapods管理https://yq.aliyun.com/articles/8315
workspace 'SISpeciesNotes.xcworkspace'
xcodeproj 'SISpeciesNotes.xcodeproj'

target 'SISpeciesNotes' do
    platform :ios, '8.0'
    use_frameworks!
    xcodeproj 'SISpeciesNotes.xcodeproj'
    
    #pod 'RealmSwift', '~> 0.98.2'
    pod 'ObjectMapper', '= 1.1.5'
    
    pod 'Alamofire', '~> 3.0'
    #alamofire组件
    pod 'AlamofireImage', '~> 2.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 1.0'
    
    #
    pod 'SDWebImage', '~>3.7'
    pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
    
    #autolayout框架
    pod 'Masonry'  #OC
    pod 'SnapKit', '~> 0.20.0'  #swift
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
    def testing_pods
        pod 'Quick'
        pod 'Nimble'
        pod 'RxBlocking', '~> 2.0'
        pod 'RxTests',    '~> 2.0'
    end

    target 'SISpeciesNotesTests' do
        testing_pods
    end

    target 'SISpeciesNotesUITests' do
        testing_pods
    end
end

target 'ScaryBugsMac' do
    platform :osx, '10.6'
    use_frameworks!
    xcodeproj 'ScaryBugsMac/ScaryBugsMac.xcodeproj'
    pod 'EDStarRating'
end


















