#存在多个project的workspace中引入cocoapods管理 https://yq.aliyun.com/articles/8315
workspace 'SISpeciesNotes.xcworkspace'
#project 'SISpeciesNotes.xcodeproj'

def snapKit
    pod 'SnapKit', '~> 0.30.0.beta2'  #swift
end

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

target 'SISpeciesNotes' do
    platform :ios, '8.0'
    use_frameworks!
    inhibit_all_warnings!
    project 'SISpeciesNotes.xcodeproj'
    
    pod 'RealmSwift', '~> 1.0.1'
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
#    pod 'SnapKit', '~> 0.20.0'  #swift
    snapKit
    #pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
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

def pBBReader   #def名不能以大写字母开头
    pod 'EDStarRating'
    #    pod 'SwiftWebSocket'
    pod 'CocoaAsyncSocket'
    #    pod 'RealmSwift'
    pod 'FMDB'
end

target 'ScaryBugsMac' do
    platform :osx, '10.11'
    use_frameworks!
    project 'ScaryBugsMac/ScaryBugsMac.xcodeproj'
       
    pBBReader
    
    target 'PBBReader' do
#        platform :osx, '10.11'
        inherit! :search_paths
        pBBReader
        snapKit
    end

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



#xcode7.3.1和cocoapods1.0版本导致playground无法import相关动态库
#解决办法：http://stackoverflow.com/questions/38216238/xcode-playground-with-cocoapods#
post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        if target.name == 'SISpeciesNotes'
            target.build_configurations.each do |config|
                config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            end
        end
        
        if target.name == 'PBBReader' || target.name == 'ScaryBugsMac'
            puts target.name
        end
    end
end

#if target.name == 'Mixpanel'
#    target.build_configurations.each do |config|
#        puts "  Pods-Mixpanel #{config.name} before: #{config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'].inspect}"
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DISABLE_MIXPANEL_AB_DESIGNER=1'
#        puts "  Pods-Mixpanel #{config.name} after:  #{config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'].inspect}"
#    end
#end


#An example of a more complex Podfile linking an app and its test bundle
#注意：必须放在最后
#解决:'GCDAsyncSocket.h' file not found   ===
#clang: error: linker command failed with exit code 1 (use -v to see invocation)
#导致的问题：playground中无法找到对应的库例如：import RxSwift 提示：no such module 'RxSwift'
#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        puts target.name
#    end
#end






