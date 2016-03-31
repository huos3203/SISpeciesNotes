#### [Realm数据库基础教程](http://www.jianshu.com/p/052c763d5693?utm_campaign=hugo&utm_medium=reader_share&utm_content=note&from=singlemessage&isappinstalled=0)

/Users/pengyucheng/git/SISpeciesNotes/readme.md


[Alcatraz安装](http://alcatraz.io)


####[Xcode 7智能测试化工具XCTestCase学习](http://www.jianshu.com/p/f4ba532caed0)



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
从版本库中移除realm包，并加入.gitignore文件中，让git不在跟踪。
只在本地工作区中存在。
```
git rm --cached Frameworks/
```