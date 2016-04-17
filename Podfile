platform :ios, "8.0"
use_frameworks!   #http://blog.csdn.net/remote_roamer/article/details/47835347
#在PodFile中使用 use_frameworks!,让cocoapods来使用framework的方式
#pod update 成功好以后，打开workspace文件
#在Project > General > Linked Framework and Libraries > 增加新生成的framework

#pod 'RealmSwift', '~> 0.98.2'
pod 'ObjectMapper', '= 1.1.5'
pod 'Alamofire', '~> 3.0'
pod 'SDWebImage', '~>3.7'
pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
pod 'OHHTTPStubs'
pod 'OHHTTPStubs/Swift'

#autolayout框架
pod 'Masonry'
pod 'SnapKit', '~> 0.20.0'
#仿UIStackView的两个开源库，用户兼容9以下版本
#OAStackView，基于OC的StackView库，支持iOS7+以上的系统。同时支持代码和IB视图。功能强大，无需质疑。
#TZStackView，基于Swift的StackView库，同样支持iOS7+以上的系统，但是不支持storyboard。
pod "TZStackView", "1.1.2"

#target :<#TargetName#>Tests, :exclusive => true do
# pod 'Kiwi'
#end