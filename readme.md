#### [Realm数据库基础教程](http://www.jianshu.com/p/052c763d5693?utm_campaign=hugo&utm_medium=reader_share&utm_content=note&from=singlemessage&isappinstalled=0)

/Users/pengyucheng/git/SISpeciesNotes/readme.md


[Alcatraz安装](http://alcatraz.io)


#### [Xcode 7智能测试化工具XCTestCase学习](http://www.jianshu.com/p/f4ba532caed0)



####学习Swift 设计模式
1. 创建型
2. 结构型
3. 行为型

第一步：建模，
数据模型Album，视图模型:AlbumView

第二步：建目录 Model,view,Controller ,API 整理mvc结构
MVVM  :三大元素，各司其职，减少依赖,视图层不依赖任何模型层的具体实现，那么就可以很容易的被其他模型复用，用来展示不同的数据,

第三步：单例模式 singlton
作用：管理数据层数据，提供后台服务的类

####问题
1. image not found  
2. dylib依赖问题
解决办法：Build Phases -> Copy Files 中点击 + 添加Realm.framework,RealmSwift.framework

更新realmSwift最新用法
1. realm声明对象：realm()
2. Results声明： Results<Modle>
3. realm.objects(modle)
4. realm.beginWrite() ,realm.commitWrite()

####更新xcode7.3，swift版本为2.2
问题1：`Module file was created by an older version of compiler`
解决办法：下载realm最新版本0.98.6,更新Frameworks引用设置支持swift2.2

####动画自动消失的问题 
1. 实现转场协议UIViewControllerTransitioningDelegate 和动画控制器UIViewControllerAnimatedTransitioning
2. 在PresentingViewController中添加如下代码：
必须是全局变量：
let presentTransitionDelegate = SDEModalTransitionDelegate()
跳转时：toVC.transitioningDelegate = presentTransitionDelegate
1. 背景色为黑色
因为非.Custom,Presenting被直接移除，解决办法：toVC.modalPresentationStyle = .Custom

```
let isCancelled = transitionContext.transitionWasCancelled()
//取消时出问题
transitionContext.completeTransition(!isCancelled)
```


####版本管理：
1. 从版本库中移除realm包，并加入.gitignore文件中，让git不在跟踪。
只在本地工作区中存在。
```
git rm -r --cached Frameworks/
```
2. 切换远程仓库路径
查看远程仓库状态：git remote show origin
切换本地跟踪的分支：
`git branch -u origin/master`或`git branch -u gitosc/master`

####swift命令
swift -v
swift 
>:quit 退出
>:help 帮助
> let v = 3 代码行


终端执行swiftc命令http://www.tuicool.com/articles/UFbyaqy
已过时：swiftc -o hello.out helloworld.swift  
替换为：swiftc helloworld.swift
####其他命令
1. 显示Xcode的版本
xcodebuild -version
2. 显示现有的sdk
xcodebuild -showsdks
3. 获取Xcode的内部Developer目录的路径
xcode-select -print-path
4. 查询可执行的shell命令路径
xcrun -find xcodebuild -find

####问题
realm().objects(model).filter(NSPredicate(format:""))
不支持 matches 关键字
在swift中可以正常使用：self代表数组中存储的对象，用于引出对象的属性名字来做匹配

####问题：初始化CLLocationCoordinate2D
[我如何才能转换 JSON 与 CLLocationCoordinate2D 在工作Swift](http://www.itstrike.cn/Question/dda0df15-a30d-4c57-ba28-54cff8f6dd5e.html)
[[swift]将 CLLocationCoordinate2D 转换为一个字符串，它可以存储](http://www.itstrike.cn/Question/3937d966-19d5-4b00-be5b-b5fe4e422d6c.html)


####更新realm方法的使用
1. 必要条件：
创建主键：
dynamic var id = 0
override static func primaryKey() -> String? {
return "id"
}

更新方法：realm.add(model实例,update:true)
2. 对象的自更新特性:已验证
Object 实例是底层数据的动态表现，其会进行自动更新，这意味着对象不需要进行刷新。修改某个对象的属性会立刻影响到其他所有指向同一个对象的实例。
如果您的 UI 代码是基于某个特定的 Realm 对象来现实的，那么在触发 UI 重绘之前，您不用担心数据的刷新或者重新检索等问题。
2.1 通知(Notification)自更新
通过调用 addNotificationBlock 方法进行通知注册后，无论哪个 Realm, Results 或者 List 对象更新，都可以得到通知。
notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
self.tableView.reloadData()
}
2.1 键值编码
1. persons.first?.setValue(true, forKeyPath: "isFirst")
    // 将每个人的 planet 属性设置为“地球”
    persons.setValue("地球", forKeyPath: "planet")
2. 响应式编程[ReactKit](https://github.com/ReactKit)[Reactive​Cocoa](http://nshipster.cn/reactivecocoa/)

####PLAYGROUND 延时运行
 1. [SELECTOR选择器的用法](http://swifter.tips/selector/)：
 2. [@OBJC 和 DYNAMIC](http://swifter.tips/objc-dynamic/)
 3. 计时器(NSTimer文档)的学习

####官方文档学习swift 和OC的混编 关键词：Swift and Objective-C in the Same Project
