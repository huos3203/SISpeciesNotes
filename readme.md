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
`


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
`
<!--查找包含commit 哈希值的分支-->
git branch --contains <commit>
git branch -r //查看包括远程的所有分支
git branch -v //查看当前分支最后一次提交的信息

git remote -v //查看远程分支

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
dynamic var specieId = 0
override static func primaryKey() -> String? {
return "specieId"
}

更新方法：realm.add(model实例,update:true)

1.1 Realm数据库版本迁移，以及主键设置

在版本升级过程中无法完成的主键迁移操作：
fatal error: 'try!' expression unexpectedly raised an error: Error Domain=io.realm Code=0 "Primary key property 'specieId' has duplicate values after migration." [更多](http://stackoverflow.com/questions/35646546/primary-key-property-has-duplicate-values-after-migration-realm-migration)
暂时解决办法：删除APP,重新安装

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

3. 类的子集(Class Subsets)：指定realm数据库中能够存储的数据模型。
在某些情况下，您可能想要对哪个类能够存储在指定 Realm 数据库中做出限制。
let config = Realm.Configuration(objectTypes: [MyClass.self, MyOtherClass.self])
let realm = try! Realm(configuration: config)



3. 线程：唯一的修改操作就是包含在写事务中的操作
Realm 通过确保每个线程始终拥有 Realm 的一个快照，以便让并发运行变得十分轻松。你可以同时有任意数目的线程访问同一个 Realm 文件，并且由于每个线程都有对应的快照，因此线程之间绝不会产生影响。
您唯一需要注意的一件事情就是不能让多个线程都持有同一个 Realm 对象的 实例 。如果多个线程需要访问同一个对象，那么它们分别会获取自己所需要的实例（否则在一个线程上发生的更改就会造成其他线程得到不完整或者不一致的数据）。
3.1 检视其他线程上的变化（刷新时机）
    1. 在主 UI 线程中（或者任何一个位于 runloop 中的线程），对象会在 runloop 的每次循环过程中自行获取其他线程造成的更改。
    2. 当您第一次打开 Realm 数据库的时候，它会根据最近成功的写事务提交操作来更新当前状态，并且在刷新之前都将一直保持在当前版本。
    3. Realm 会自每个 runloop 循环的开始自动进行刷新，除非 Realm 的 autorefresh 属性设置为 NO。如果某个线程没有 runloop 的话（通常是因为它们被放到了后台进程当中），那么 Realm.refresh() 方法必须手动调用，以确保让事务维持在最新的状态当中。

    4. Realm 同样也会在写入事务提交(Realm.commitWrite())的时候刷新。
3.2 跨线程传递实例（通过不同的实例方法，来获取数据库中的对象）
Object 的单例（未保存的）表现的和正常的 NSObject 子类相同，可以安全地跨线程传递。

Realm、Object、Results 或者 List 已保存的实例只能够在它们被创建的线程上使用，否则就会抛出异常*。这是 Realm 强制事务版本隔离的一种方法。否则，在不同事务版本中的线程间，通过潜在泛关系图(potentially extensive relationship graph)来确定何时传递对象将不可能实现。
* 这些类型的某些属性和方法可以在任意线程中进行访问：

Realm: 所有的属性、类方法和构造器；all properties, class methods, and initializers.
Object: invalidated、objectSchema、realm，以及所有的类方法和构造器；
Results: objectClassName 和 realm；
List: invalidated、objectClassName 和 realm。

3.3 跨线程使用数据库
为了在不同的线程中使用同一个 Realm 文件，您需要为您应用的每一个线程初始化一个新的Realm 实例。 只要您指定的配置是相同的，那么所有的 Realm 实例都将会指向硬盘上的同一个文件。

我们还 不支持 跨线程共享Realm 实例。 Realm 实例要访问相同的 Realm 文件还必须使用相同的 Realm.Configuration。



#### [PLAYGROUND 延时运行](http://swifter.tips/playground-delay/) 
延时执行的黑魔法：
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)

 1. [SELECTOR选择器的用法](http://swifter.tips/selector/)
    selector 其实是 Objective-C runtime 的概念，如果你的 selector 对应的方法只在 Swift 中可见的话 (也就是说它是一个 Swift 中的 private 方法)，在调用这个 selector 时你会遇到一个 unrecognized selector 错误：
    1. 在 private 前面加上 @objc 关键字，这样运行时就能找到对应的方法
    2. 在通过字符串生成 Selector 时，约定：如果方法的第一个参数有外部变量的话，需要在方法名和第一个外部参数之间加上 with例如：let s = Selector("aMethodWithExternal:")

 2. [@OBJC 和 DYNAMIC](http://swifter.tips/objc-dynamic/)
    1. @objc：在可选协议只能在含有@objc前缀的协议中生效，且@bjc的协议只能被类遵循，
    2. 以及swift和OC混编时用到
    3. @objc 修饰符的另一个作用是为 Objective-C 使用swift代码，重新声明方法或者变量的名字 
Objective-C 的话是无法使用中文来进行调用的，因此我们必须使用 @objc 将其转为 ASCII 才能在 Objective-C 里访问：
@objc(MyClass)
class 我的类 {
@objc(greeting:)
func 打招呼(名字: String) {
print("哈喽，\(名字)")
}
}
##### 两套完全不同的机制：一个运行时（注重严谨：遵循KVC和动态派发），一个编译时（注重性能：编译时类型成员和方法就已经确定）
Objective-C 和 Swift 在底层使用的是两套完全不同的机制，Cocoa 中的 Objective-C 对象是基于运行时的，它从骨子里遵循了 KVC (Key-Value Coding，通过类似字典的方式存储对象信息) 以及动态派发 (Dynamic Dispatch，在运行调用时再决定实际调用的具体实现)。而 Swift 为了追求性能，如果没有特殊需要的话，是不会在运行时再来决定这些的。也就是说，Swift 类型的成员或者方法在编译时就已经决定，而运行时便不再需要经过一次查找，而可以直接使用。
##### @objc 修饰符：两种添加方式，一种是自动添加（继承自NSObjct时），一种需要主动添加（private，重命名等）
显而易见，这带来的问题是如果我们要使用 Objective-C 的代码或者特性来调用纯 Swift 的类型时候，我们会因为找不到所需要的这些运行时信息，而导致失败。解决起来也很简单，在 Swift 类型文件中，我们可以将需要暴露给 Objective-C 使用的任何地方 (包括类，属性和方法等) 的声明前面加上 @objc 修饰符。注意这个步骤只需要对那些不是继承自 NSObject 的类型进行，如果你用 Swift 写的 class 是继承自 NSObject 的话，Swift 会默认自动为所有的非 private 的类和成员加上 @objc。这就是说，对一个 NSObject 的子类，你只需要导入相应的头文件就可以在 Objective-C 里使用这个类了。

在OC项目中，使用swift语言扩展了String,新增了个方法，为什么在自动生成的文件-Swift.h中，没有生成这个扩展方法呢？
三剑客品JAVA  12:20:24
大家遇到过这个问题吗，扩展类类型的方法时暴露给OC 使用@objc注释一下就行的，但是在扩展String值类型时，怎么处理呢？


Swift兼容大部分ObjC（通过类似上面的对应关系），多数ObjC的功能在Swift中都能使用。当然，还是有个别地方Swift并没有考虑兼容ObjC，例如：Swift中无法使用预处理指令（例如：宏定义，事实上在Swift中推举使用常量定义）；Swift中也无法使用performSelector来执行一个方法，因为Swift认为这么做是不安全的。

相反，如果在ObjC中使用Swift也同样是可行的（除了个别Swift新增的高级功能）。Swift中如果一个类继承于NSObject，那么他会自动和ObjC兼容，这样ObjC就可以按照上面的对应关系调用Swift的方法、属性等。但是如果Swift中的类没有继承于NSObject呢？此时就需要使用一个关键字“@objc”进行标注，ObjC就可以像使用正常的ObjC编码一样调用Swift了（事实上继承于NSObject的类之所以在ObjC中能够直接调用也是因为编译器会自动给类和非private成员添加上@objc，类似的@IBoutlet、@IBAction、@NSManaged修饰的方法属性，Swift编译器也会自动添加@objc标记）。





 3. 计时器(NSTimer文档)的学习

####官方文档学习swift 和OC的混编 关键词：Swift and Objective-C in the Same Project

####[Swift如何检测系统版本](http://www.cocoachina.com/swift/20141015/9925.html)
let os = NSProcessInfo().operatingSystemVersion
switch (os.majorVersion, os.minorVersion, os.patchVersion) {
case (8, _, _):
println("iOS >= 8.0.0")
case (7, 0, _):
println("iOS >= 7.0.0, < 7.1.0")
case (7, _, _):
println("iOS >= 7.1.0, < 8.0.0")
default:
println("iOS < 7.0.0")
}

####编译错误：
1.  Declaration of 'RLMNotificationToken' must be imported from module 'Realm.RLMRealm' before it is required
    诱发原因：在xcode7.2.1下编译swift和OC混编项目时，Realm的通知变量在-swift.h文件中爆出错误。就是说在swift2.2.1版本中，不支持Realm工具的混编。
    解决办法1：删除混编配置文件-swift.h ，在build setting 中移除 $(SWIFT_MODULE_NAME)-Swift.h
    解决办法2：在swift代码中不使用realm.addNotificationBlock特性。

2. 鹏保宝swift和OC婚变时出现错误：在真机调试时，编译成功后，运行时直接崩溃。
   1. For the device, you also need to add the dynamic framework to the Embedded binaries section in the General tab of the project.
   2. Swift的错误
    dyld: Library not loaded: @rpath/libswiftCore.dylib ，  Reason: image not found
    原因：因为鹏保宝是一个project对应多个target，容易导致在新建swift文件时，xcode自动生成桥文件和混编配置，默认配置到PBB target中，导致运行PBBReader时，一直出现因配置导致image not found的崩溃错误.
解决办法：不要右击新建文件：否则会默认创建在PBB target中，尽量使用菜单新建swift文件或者拖拉方式关联已存在的swift关联到PBBReader target中。即：新建文件时，要出现关联到target的提示框，这样就可以避免配上的问题。

#####扩展UILabel控件，添加实现24s间隔，位置随机移动动画中遇到的问题，及解决办法。
1. 只能扩展类型存储属性，方法，构造器，计算属性，类型计算属性。
2. 通过计算属性，获取自定义Label随机位置CGPoint。
2. 想法1：通过类型存储属性来持有NSTimer对象，这样就可以在视频页面通过UILabel实例对NSTimer进行invalidate关闭操作。
    -- 经实践无法扩展class var 属性名  ，系统提示static修饰类型存储属性，在混编中PBBReader-Swift.h文件无法映射该类型存储属性，导致在OC代码中无法调用UILabel的扩展功能。
   想法2： 通过方法的In-out形参方法来传递NSTimer对象，FireTimer(inout timer:NSTimer),调用方法：UILabel().FireTimer(&timer),使用强制指针的形式，将timer指向UILabel中声明的NSTimer对象，这样就可以在视屏控制器中，来引用NSTimer对象，来执行invalid关闭操作。
    -- 经实验失败，在使用inout修饰FireTimer(inout timer:NSTimer)参数时， 在混编PBBReader-Swift.h文件中，因inout，导致该方法无法正常映射，故失败。
   想法3：通过使用匿名函数的捕捉上下文的变量和常量的特性，FireTimer()->()->()方法的返回类型的特性来获取NSTimer对象操作权，来执行invalidate关闭操作。
    -- 在混编中fireTimer()->()-(){return {timer.invalidate()}} 映射成：- (void (^ __nonnull)(void))fireTimer; 
        可以看出，PBBReader-Swift.h文件中能够正确自动映射，函数类型：()->()隐射成block块：void(^ __nonnull)(void)，所以能在视屏控制器中声明一个block块属性，来接收该方法的返回的block块，在退出时执行该block块 来关闭NSTimer对象。
4. OC中block的声明格式：
定义块的语法格式： ^[块返回值类型](形参类型1 形参名,形参类型2 形参名,形参类型3 形参名,形参类型4vv 形参名,...){  //块执行体  }
    1. 定义块必须以 ^ 开头。
    2. 定义块返回值类型可以忽略，而且经常都会省略声明块的返回值类型。
    3. 定义块无须指定名字。
    4. 如果没有参数，此时参数部分的括号不能省略，但内容可以留空，通常使用void作为占位符。
定义块变量： 如果程序需要以后多次调用已经定义的块，可以将定义块赋值给块变量。
    格式：块返回值类型(^块变量名)(形参类型1,形参类型2,形参类型3...);

void (^myblock)(int,int) = ^(int名,init名2){//执行体     NSLog("数字＝%d",int名)}

块与局部变量：块可以访问局部变量的值，不被允许修改局部变量的值。定义块时就会把局部变量的值复制到块中，而不是等到执行时才去访问，获取局部变量的值。
__block 修饰符: 块可以直接使用__block修饰的局部变量本身，而不是将局部变量的值复制到块范围内。这类似与swift函数中inout参数强引用的作用，这时block可以修改局部变量不会导致错误，而且在任何时候都能获取到在程序其他操作导致更新了局部变量的最新值。

####typedef:定义块变量类型
1. 复用块变量类型，使用块变量类型可以重复定义多个块变量。
2. 使用块变量类型定义函数参数，这样即可定义带块参数的函数。

typedef void (^块变量名)(形参类型1,行藏类型2...);
例如：typedef void(^Myblock)(NSString*);  声明了一个块变量类型 Myblock
使用：
声明一个block块： Myblock 块变量名;      初始化： 块变量名 = ^(形参名1,形参名2...){ //块体 }

声明一个带块参数的函数：
类型：typedef void(^Myblock)(NSString*);
方法：void myfunc(int len, Myblock block){//函数体}



####Realm再混时遇到的问题：
在OC代码中引入-Swift.h文件后，原Swift代码中使用了RLMNotificationToken特性后，会出现以下提示：
Declaration of 'RLMNotificationToken' must be imported from module 'Realm.RLMResults' before it is required

#####初始化存储属性：函数变量
var invalidTimer:()->() = {}
//在不需要神
_ = ibShadeLabel.fireTimer()


##### “No such module” when using @testable in Xcode Unit tests
[Xcode：为你的项目集成单元测试时记得避开这些坑](http://www.cocoachina.com/ios/20151125/14415.html)
[“No such module” when using @testable in Xcode Unit tests](http://stackoverflow.com/questions/32008403/no-such-module-when-using-testable-in-xcode-unit-tests)
[详解Swift 2.0（一）：单元测试与模式匹配](xcode特性：http://www.tuicool.com/articles/rMzMjaa)

最终解决办法：
1. 主项目的target的配置中设置： build settings -> enable testability -> debug设置为YES
2. 确保SISpeciesnotesTests的 build setting -> build active architecture Only ->debug选项设置为YES

#### [UnitTest特性](http://www.cocoachina.com/industry/20140805/9314.html) 
1. self.measureBlock:能够检测代码性能：self.measureBlock() {//测试代码块}
2. XCTestExpectation:异步测试的支持，借助 XCTestExpectation 类来实现。现在，测试能够为了确定的合适的条件等待一个指定时间长度，而不需要求助于GCD.

#### 做一个异步测试:
第一步，期望值：let expectation = expectationWithDescription("...") 
第二步，增加 waitForExpectationsWithTimeout 方法，指定一个超时，如果测试条件不适合时间范围便会结束执行：
waitForExpectationsWithTimeout(10, handler: { error in 
// ... 
})  
第三步，返回期望值：现在，剩下的步骤是在异步方法被测试的相关的回调中实现那个期望值。
expectation.fulfill() 
如果测试有不止一个期望值，它将不会通过，除非每一次期望值在被 inwaitForExpectationsWithTimeout() 指定的超时中执行 fulfill()。
expectation.fulfill() 


##### 异常处理Error handing

##### try? Converting Errors to Optional Values
You use try? to handle an error by converting it to an optional value. If an error is thrown while evaluating the try? expression, the value of the expression is nil.
func someThrowingFunction() throws -> Int {
// ...
}

let x = try? someThrowingFunction()

let y: Int?
do {
y = try someThrowingFunction()
} catch {
y = nil
}
##### try! 禁止错误传递
Disabling Error Propagation

Sometimes you know a throwing function or method won’t, in fact, throw an error at runtime. On those occasions, you can write try! before the expression to disable error propagation and wrap the call in a runtime assertion that no error will be thrown. If an error actually is thrown, you’ll get a runtime error.

For example, the following code uses a loadImage(_:) function, which loads the image resource at a given path or throws an error if the image can’t be loaded. In this case, because the image is shipped with the application, no error will be thrown at runtime, so it is appropriate to disable error propagation.

let photo = try! loadImage("./Resources/John Appleseed.jpg")

#### defer关键字 A defer statement defers execution until the current scope is exited
This statement lets you do any necessary cleanup that should be performed regardless of how execution leaves the current block of code—whether it leaves because an error was thrown or because of a statement such as return or break.


##### [How to Use CocoaPods with Swift](https://www.raywenderlich.com/97014/use-cocoapods-with-swift)
@testable import SISpeciesNotes
@testable import Alamofire
@testable import ObjectMapper
@testable import OHHTTPStubs

第一步：配置Podfile 添加use_frameworks!  ，pod 'Alamofire'  
第二步：安装 pod install
第三步：在Swift文件中导入动态库 import Almofire ，此时会有错误，暂时不用处理，等command + b 编译完成就可以正常使用Almofire库提供的API

###### 怎样能在UnitTest中使用pod安装过的Framework呢
前提在以上三步的基础上，如果直接使用@testable import Alamofire ,会提示“No such module” when using @testable in Xcode Unit tests
只需要进入 Pods项目配置文件中，选中Target-> Almofire ,在该target中设置build settings -> enable testability -> debug设置为YES ，再重新编译 command + b 主项目，此时 Unit tests中的引用问题就消失了 

##### 在Playgroud中使用个人项目中的类相关方法，需要借助于Custom Frameworks桥接
解决方法：查看官方文档：Playground help -> Importing Custom Frameworks into a Playground

1. 导入个人项目文件，需要借助cocoa touch Framework来桥接playground
2. 需要workspace来管理Framework项目和playground文件，典型例子：pod项目都是用workspace来管理多个项目。
3. 把个人项目的swift文件关联到Cocoa touch Framework项目的target中：
    详细设置：选中target -> build phases -> compiles sources ->点击 + 加号，选中原项目中的swift
    .swift的文件中的方法必须是public修饰。
4. 在build选项中选中Framework的scheme进行编译 
5. 打开playground文件 import Framework名称，此时即可使用Framework中的提供的public API方法了。

注意：Workspace相关设置，build生成的目录：xcode偏好设置要和项目中的workspace中设置要保持一致.
    1. xcode的偏好设置中 ->Locations -> Locations ->点击打开 Advanced...在弹出框中设置Unique选项.
    2. 在workspace中选中菜单 File -> workspace settings... -> 在弹出框中设置为Unique选项.
    

[How to I import 3rd party frameworks into Xcode Playground?](http://stackoverflow.com/questions/24046160/how-to-i-import-3rd-party-frameworks-into-xcode-playground)
[How to import own classes from your own project into a Playground](http://stackoverflow.com/questions/24045245/how-to-import-own-classes-from-your-own-project-into-a-playground)

Your playground must be in the same workspace as the project that produces your framework. Your workspace must contain a target that produces the framework, instead of using a pre-built framework.

You must have already built your framework. If it is an iOS framework, it must be built for a 64-bit run destination (e.g. iPhone 5s), and must be built for the Simulator.

You must have an active scheme which builds at least one target (that target's build location will be used in the framework search path for the playground).

Your "Build Location" preference (in advanced "Locations" settings of Xcode) should not be set to "Legacy".

If your framework is not a Swift framework the "Defines Module" build setting must be set to "Yes".

You must add an import statement to your playground for the framework.


#### NSURLConnection 和 NSURLSession请求网络的一个坑
在主项目中使用 
1. NSURLConnection 请求网络https://www.baidu.com时，必须设置NSAppTransportSecurity-> NSAllowsArbitraryLoads = true
2. NSURLSession请求网路时，则没有这个要求
3. 坑在此：在Unit test中使用NSURLConnection时，在Unit test的info.plist文件中配置无效，必须在祝项目中的plist文件中重复第二步操作。 
 

