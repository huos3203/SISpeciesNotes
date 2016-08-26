/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxSwift-OSX** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
/*:
 # Creating and Subscribing to `Observable`s
 There are several ways to create and subscribe to `Observable` sequences.
 ## never
 Creates a sequence that never terminates and never emits any events. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 
 never 创建一个序列，该序列永远不会发送消息， .Completed 消息也不会发送。
 */
example("never") {
    let disposeBag = DisposeBag()
    let neverSequence = Observable<String>.never()
    
    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
    }
    
    neverSequenceSubscription.addDisposableTo(disposeBag)
}
/*:
 ----
 ## empty
 Creates an empty `Observable` sequence that only emits a Completed event. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 
 empty 创建一个空的序列。它仅发送 .Completed 消息。
 */
example("empty") {
    let disposeBag = DisposeBag()
    
    Observable<Int>.empty()
        .subscribe { event in
            print(event)
        }
        .addDisposableTo(disposeBag)
}
/*:
 > This example also introduces chaining together creating and subscribing to an `Observable` sequence.
 ----
 ## just
 Creates an `Observable` sequence with a single element. [More info](http://reactivex.io/documentation/operators/just.html)
 
 just 代表只包含一个元素的序列。它将向订阅者发送两个消息，第一个消息是其中元素的值，另一个是 .Completed 。
 */
example("just") {
    let disposeBag = DisposeBag()
    
    Observable.just("🔴")
        .subscribe { event in
            print(event)
        }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## of
 Creates an `Observable` sequence with a fixed number of elements.
 
 Of 通过固定数目的元素创建一个序列
 */
example("of") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .subscribeNext { element in
            print(element)
        }
        .addDisposableTo(disposeBag)
}
/*:
 > This example also introduces using the `subscribeNext(_:)` convenience method. Unlike `subscribe(_:)`, which subscribes an _event_ handler for all event types (Next, Error, and Completed), `subscribeNext(_:)` subscribes an _element_ handler that will ignore Error and Completed events and only produce Next event elements. There are also `subscribeError(_:)` and `subscribeCompleted(_:)` convenience methods, should you only want to subscribe to those event types. And there is a `subscribe(onNext:onError:onCompleted:onDisposed:)` method, which allows you to react to one or more event types and when the subscription is terminated for any reason, or disposed, in a single call:
 ```
 someObservable.subscribe(
     onNext: { print("Element:", $0) },
     onError: { print("Error:", $0) },
     onCompleted: { print("Completed") },
     onDisposed: { print("Disposed") }
 )
```
 ----
 ## toObservable
 Creates an `Observable` sequence from a `SequenceType`, such as an `Array`, `Dictionary`, or `Set`.
 
 toObservable 在一个数组的基础上创建一个序列
 */
example("toObservable") {
    let disposeBag = DisposeBag()
    
    ["🐶", "🐱", "🐭", "🐹"].toObservable()
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 > This example also demonstrates using the default argument name `$0` instead of explicitly naming the argument.
----
 ## create
 Creates a custom `Observable` sequence. [More info](http://reactivex.io/documentation/operators/create.html)
 
 create 使用 Swift 闭包来创建一个序列。该例子中，创建了 just 操作符的自定义版本。
*/
example("create") {
    let disposeBag = DisposeBag()
    
    let myJust = { (element: String) -> Observable<String> in
        return Observable.create { observer in
            observer.on(.Next(element))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
        
    myJust("🔴")
        .subscribe { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## range
 Creates an `Observable` sequence that emits a range of sequential integers and then terminates. [More info](http://reactivex.io/documentation/operators/range.html)
 */
example("range") {
    let disposeBag = DisposeBag()
    
    Observable.range(start: 1, count: 10)
        .subscribe { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## repeatElement
 Creates an `Observable` sequence that emits the given element indefinitely. [More info](http://reactivex.io/documentation/operators/repeat.html)
 */
example("repeatElement") {
    let disposeBag = DisposeBag()
    
    Observable.repeatElement("🔴")
        .take(3)
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 > This example also introduces using the `take` operator to return a specified number of elements from the start of a sequence.
 ----
 ## generate
 Creates an `Observable` sequence that generates values for as long as the provided condition evaluates to `true`.
 
 generate 创建的序列可以自己生成它的值，并且在之前值的基础上来判断什么时候结束。
 */
example("generate") {
    let disposeBag = DisposeBag()
    
    Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
        )
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## deferred
 Creates a new `Observable` sequence for each subscriber. [More info](http://reactivex.io/documentation/operators/defer.html)
 
 直到 observer 订阅之后才创建 Observable，并且为每一个 observer 创建一个全新的 Observable  
 ![](defer.png)
 
 */

example("deferred") {
    let disposeBag = DisposeBag()
    var count = 1
    
    let deferredSequence = Observable<String>.deferred {
        print("Creating \(count)")
        count += 1
        
        return Observable.create { observer in
            print("Emitting...")
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐵")
            return NopDisposable.instance
        }
    }
    
    deferredSequence
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    
    deferredSequence
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## error
 Creates an `Observable` sequence that emits no items and immediately terminates with an error.
 
 创建一个不发送任何 item 的 Observable，以 error 终止。
 */
example("error") {
    let disposeBag = DisposeBag()
    //let error = NSError(domain: "Test", code: -1, userInfo: nil)
    
    Observable<Int>.error(Error.Test)
        .subscribe { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 ----
 ## doOn
 Invokes a side-effect action for each emitted event and returns (passes through) the original event. [More info](http://reactivex.io/documentation/operators/do.html)
 
 注册一个操作来监听事件的生命周期（register an action to take upon a variety of Observable lifecycle events）
 ![](doOn.png)
 */
example("doOn") {
    let disposeBag = DisposeBag()
    
    Observable.of("🍎", "🍐", "🍊", "🍋")
        .doOn { print("Intercepted:", $0) }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
//: > There are also `doOnNext(_:)`, `doOnError(_:)`, and `doOnCompleted(_:)` convenience methods to intercept those specific events, and `doOn(onNext:onError:onCompleted:)` to intercept one or more events in a single call.

//: [Next](@next) - [Table of Contents](Table_of_Contents)
