#存在多个project的workspace中引入cocoapods管理 https://yq.aliyun.com/articles/8315
#CocoaPods是用ruby实现的，因此Podfile文件的语法就是ruby的语法。接着从以下几个方面来介绍Podfile:
# `gem install cocoapods --pre`
# `pod search AlamofireImage`
source 'https://github.com/CocoaPods/Specs.git'
workspace 'SISpeciesNotes.xcworkspace'
#project 'SISpeciesNotes.xcodeproj'

def snapKit
    pod 'SnapKit', '~> 3.0.2'  ##swift3.0
end

#添加单元测试依赖库
#介绍： https://realm.io/cn/news/tryswift-ash-furrow-artsy-testing-tour/
#https://github.com/Quick/Quick/blob/master/Documentation/en-us/InstallingQuick.md#cocoapods
#Specta让我们采用行为驱动开发(BDD)风格的语法来编写测试，相比于XCTest的语法，它更加易读。它还有一个强大的分组测试功能，在测试之前或之后运行一些代码块，这样的话，能够极大地减少重复代码。

#    Expecta是一个匹配器框架，我们可以在测试中使用它来创建断言。它的语法非常强大，与此同时，它比内建的XCAssert套件更加易读。例如
def testing_pods
    pod 'Quick',  '~> 0.10.0'       #Specta “可视化”测试
    pod 'Nimble', '~> 5.0.0'        # Expecta 匹配器框架
    pod 'RxBlocking', '~> 3.0'
    #        pod 'RxTests',    '~> 2.0'  #失败，无法集成https://github.com/ReactiveX/RxSwift/issues/472
end

#https://fabric.io/kits/ios/crashlytics/install
def addFabric
    pod 'Fabric'
    pod 'Crashlytics'
end

target 'InstrumentsTutorial' do
    platform :ios, '8.0'
    use_frameworks!
    project 'InstrumentsSwift-Starter/InstrumentsTutorial.xcodeproj'
    #添加
    addFabric

end

# def swift3
# 
# end

target 'SISpeciesNotes' do
    platform :ios, '10.0'
    use_frameworks!
    inhibit_all_warnings!
    project 'SISpeciesNotes.xcodeproj'
    
    pod 'RealmSwift', '~> 2.0.3'
    pod 'ObjectMapper', '~> 2.2'
   
    pod 'Alamofire', '~> 4.0'   #swift3.0
    #alamofire组件
    pod 'AlamofireImage', '~> 3.1.0' #swift3.0
    pod 'AlamofireNetworkActivityIndicator', '~> 2.0' #swift3.0
    
    #
    pod 'SDWebImage', '~>3.7'
    pod 'OHHTTPStubs', '~> 5.2.2' # Default subspecs, including support for NSURLSession & JSON etc
    pod 'OHHTTPStubs/Swift' # Adds the Swiftier API wrapper too
    #autolayout框架
    pod 'Masonry'  #OC
    snapKit
    #pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    #------仿UIStackView的两个开源库，用户兼容9以下版本-----
    #OAStackView，基于OC的StackView库，支持iOS7+以上的系统。同时支持代码和IB视图。功能强大，无需质疑。
    #TZStackView，基于Swift的StackView库，同样支持iOS7+以上的系统，但是不支持storyboard。
    #pod "TZStackView", "1.1.2"
    
    
    #工具
    pod  'SwiftFilePath'
    
    #mustache模板引擎
    pod 'GRMustache.swift', '~> 2.0.0'
    
    #热修复/热更新库
    pod 'JSPatch'
    
    #响应式开发依赖库 https://realm.io/cn/news/slug-max-alexander-functional-reactive-rxswift/
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'

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
#在写入磁盘之前，修改一些工程的配置:
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name != 'CocoaAsyncSocket'
            #playground相关配置，会导致'GCDAsyncSocket.h' file not found
            target.build_configurations.each do |config|
                config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
                
                #Use Legacy Swift Language Version” (SWIFT_VERSION):
                #   https://github.com/CocoaPods/CocoaPods/issues/5864#issuecomment-247109685
                puts "SWIFT_VERSIION:"
                config.build_settings['SWIFT_VERSION'] = "3.0.1"
                puts config.build_settings['SWIFT_VERSION']
            end
        else
            #输出操作
            puts "以下不能在playground中使用的库名："
            puts target.name
        end
    end
end


#http://pastebin.com/bsnsC2Ab
#if target.name == 'Mixpanel'
#    target.build_configurations.each do |config|
#        puts "  Pods-Mixpanel #{config.name} before: #{config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'].inspect}"
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DISABLE_MIXPANEL_AB_DESIGNER=1'
#        puts "  Pods-Mixpanel #{config.name} after:  #{config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'].inspect}"
#    end
#end

#升级cocopods
# sudo gem update --system
# gem source -l
# pod setup
# pod repo update --verbose
# sudo gem install cocoapods --pre
# sudo gem cleanup

# target 'MyApp' do
#   swift_version = '2.3'
# end


