//: Playground - noun: a place where people can play

//[原文路径](https://realm.io/cn/news/slug-max-alexander-functional-reactive-rxswift/)
//RxSwift 是一个全新的第三方库，让您的事件驱动 (event-driven) 应用更容易进行管理，增强代码的可读性，从而减少错误的发生，让您不再为此而烦恼
//: Rx 权利法案 (4:09)
    //:  我们的开发者拥有像管理迭代集合 (iterable collections) 一样管理异步事件的权利。
//:在 Rx 的世界里，让我们用观察者 (Observables) 的概念来代替数组。观察者是一个类型安全的事件对象，可以长期对不同种类的数据值进行写入和读出。
import Foundation
import RxSwift

//: 在处理不同事件的时候，无论如何你都会持有一个包含这些事件的集合。

var str = [1, 2, 3, 4, 5, 6].filter{ $0 % 2 == 0 }
str

//: 给这个数组中的所有元素都乘以 5 然后生成一个新数组
var mapstr = [1, 2, 3, 4, 5, 6].map{ $0 * 5 }
mapstr

//: 执行加法操作
var reducestr = [1, 2, 3, 4, 5, 6].reduce(0, combine: +)
reducestr

//: 创建观察者 -----------------
//:  just是一个RxSwift 内建的函数:你可以将你所想要的变量放到其中，它就会返回一个包含相同类型的观察者变量。
Observable.just(1)  //返回Observable<Int>对象

//: 从数组中一个接一个的推出元素并执行相关操作
[1,2,3,4,5,6].toObservable()  //返回Observable<Int>对象

//: create是一个RxSwift 内建的函数: 返回一个闭包,这个闭包会需要一个观察者参数，这意味着有某个东西正在对其进行观察。

/*
create { (observer: AnyObserver<AuthResponse>) -> Disposable in
    
    let request = MyAPI.get(url, ( (result, error) -> {
        if let err = error {
        observer.onError(err);
        }
        else if let authResponse = result {
        observer.onNext(authResponse);
        observer.onComplete();
        }
        })
        return AnonymousDisposable {
        request.cancel()
    }
}
 //: observer.onError() 方法:当存在错误的时候调用,这意味着只要监听了这个对象的代码都会接收到这个错误消息.
 //: observable.onNext() 方法:当得到可用的服务器回应时调用。
 //: observable.onComplete()方法:当处理结束时调用。这个时候我们就到了 AnonymousDisposable 这里了。
 //: AnonymousDisposable 闭包: 是当你想要中止请求的时候被调用的操作。比如说你离开了当前视图控制器或者应用已经不再需要调用这个请求的时候，就可以使用这个方法了。这对视频上传等大文件操作是非常有用的。当你结束所有操作的时候，request.cancel() 可以清除所有的资源。无论是操作完成还是发生错误，这个方法都会被调用。
*/

//: 监听观察者-----------------
//toObservable():在很多系统对象中新增的一个扩展方法
//: subscribeNext监听函数:
[1,2,3,4,5,6]
    .toObservable()
    .subscribeNext {
        print($0)
}

//: Subscribe 监听器事件基于失败请求、下一步事件以及 onCompleted 操作，提供了各种各样的信息。你可以有选择性的建立相应的监听：
[1,2,3,4,5,6]
    .toObservable()
    .subscribe(onNext: { (intValue) -> Void in
        // 推出一个整数数据
        }, onError: { (error) -> Void in
            // 发生错误！
        }, onCompleted: { () -> Void in
            // 没有更多的信号进行处理了
    }) { () -> Void in
        // 我们要清除这个监听器
}


//: 关联观察者-----------------
//: combineLatest关联方法： 意味着当某个事件发生的时候，我们就将最近的两个事件之间建立关联。

//func rx_canBuy() -> Observable<Bool> {
//    let stockPulse : [Observable<StockPulse>]
//    let accountBalance : Observable<Double>
//    
//    return combineLatest(stockPulse, accountBalance,
//                         resultSelector: { (pulse, bal) -> Bool in
//                            return pulse.price < bal
//    })
//}
//
//rx_canBuy()
//    .subscribeNext { (canBuy) -> Void in
//        self.buyButton.enabled = canBuy
//}

//合并merge()方法：这些参数的类型都是相同的 Observable<StockPulse> 类型。我需要知道它们何时被触发，我需要做的就是持有一个观察者数组。里面存放了我需要进行监听的多个不同种类的股票行情，我可以在一个输出流中将它们合并然后进行监听。


//let myFavoriteStocks : [Observable<StockPulse>]
//
//myFavoriteStocks.merge()
//    .subscribeNext { (stockPulse) -> Void in
//        print("\(stockPulse.symbol)/
//            updated to \(stockPulse.price)/")
//}


