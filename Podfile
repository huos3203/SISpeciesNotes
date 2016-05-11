#link_with 'SISFramework','SISpeciesNotes'  #为了把第三方开源库导入到Framwork，使用link_with来支持pod，结果并没有真正被引入，最后通过build active 的配置搞定了
platform :ios, "8.0"
use_frameworks!   #http://blog.csdn.net/remote_roamer/article/details/47835347
#在PodFile中使用 use_frameworks!,让cocoapods来使用framework的方式
#pod update 成功好以后，打开workspace文件
#在Project > General > Linked Framework and Libraries > 增加新生成的framework

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
#仿UIStackView的两个开源库，用户兼容9以下版本
#OAStackView，基于OC的StackView库，支持iOS7+以上的系统。同时支持代码和IB视图。功能强大，无需质疑。
#TZStackView，基于Swift的StackView库，同样支持iOS7+以上的系统，但是不支持storyboard。
#pod "TZStackView", "1.1.2"


#工具
pod  'SwiftFilePath'

#mustache模板引擎
pod 'GRMustache.swift', '~> 1.0'

pod 'JSPatch'

#target :<#TargetName#>Tests, :exclusive => true do
# pod 'Kiwi'
#end





#1.xcodeproj关键字： Podfile文件存放位置
#通常情况下我们都推荐Podfile文件都放在工程根目录。
#事实上Podfile文件可以放在任意一个目录下，需要做的是在Podfile中使用xcodeproj关键字指定工程的路径：
#和原来相比，Podfile文件就在最开始的位置增加了一行，具体内容如下：
#    xcodeproj "/Users/wangzz/Desktop/CocoaPodsTest/CocoaPodsTest.xcodeproj"

#2.Podfile和target
#2.1：默认： Podfile本质是用来描述Xcode工程中的targets用的。
#如果我们不显式指定Podfile对应的target，CocoaPods会创建一个名称为default的隐式target，会和我们工程中的第一个target相对应。换句话说，如果在Podfile中没有指定target，那么只有工程里的第一个target能够使用Podfile中描述的Pods依赖库。

#2.2：link_with关键字：多个target中使用相同的Pods依赖库,必须是第一个指令
#实现了CocoaPodsTest和Second两个target共用相同的Pods依赖库，将Podfile写成如下方式：
#link_with 'CocoaPodsTest', 'Second'
#platform :ios
#pod 'Reachability',  '~> 3.0.0'
#pod 'SBJson', '~> 4.0.0'
#platform :ios, '7.0'
#pod 'AFNetworking', '~> 2.0'

#2.3：target关键字：不同的target使用完全不同的Pods依赖库
#CocoaPodsTest这个target使用的是Reachability、SBJson、AFNetworking三个依赖库，
#但Second这个target只需要使用OpenUDID这一个依赖库，这时可以使用target关键字，Podfile的描述方式如下：
#target :'CocoaPodsTest' do
#    platform :ios
#    pod 'Reachability',  '~> 3.0.0'
#    pod 'SBJson', '~> 4.0.0'
#    platform :ios, '7.0'
#    pod 'AFNetworking', '~> 2.0'
#end
#target :'Second' do
#    pod 'OpenUDID', '~> 1.0.0'
#end
















