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
 # Working with Subjects
 A Subject is a sort of bridge or proxy that is available in some implementations of Rx that acts as both an observer and `Observable`. Because it is an observer, it can subscribe to one or more `Observable`s, and because it is an `Observable`, it can pass through the items it observes by reemitting them, and it can also emit new items. [More info](http://reactivex.io/documentation/subject.html)
 
 Subject 可以看成是一个桥梁或者代理，在某些ReactiveX实现中，它同时充当了 Observer 和 Observable 的角色。因为它是一个Observer，它可以订阅一个或多个 Observable；又因为它是一个 Observable，它可以转发它收到(Observe)的数据，也可以发射新的数据。
*/
extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}
//辅助函数：
func writeSequenceToConsole<O: ObservableType>(name: String, sequence: O) -> Disposable {
    return sequence.subscribe { event in
        print("Subscription: \(name), event: \(event)")
    }
}
/*:
 ## PublishSubject
 Broadcasts new events to all observers as of their time of the subscription.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png "PublishSubject")
 
 PublishSubject 只会把在订阅发生的时间点之后来自原始Observable的数据发射给观察者。
 ![](PublishSubject1.png)
 ![](PublishSubject2.png)
 */
example("PublishSubject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 > This example also introduces using the `onNext(_:)` convenience method, equivalent to `on(.Next(_:)`, which causes a new Next event to be emitted to subscribers with the provided `element`. There are also `onError(_:)` and `onCompleted()` convenience methods, equivalent to `on(.Error(_:))` and `on(.Completed)`, respectively.
 ----
 ## ReplaySubject
 Broadcasts new events to all subscribers, and the specified `bufferSize` number of previous events to new subscribers.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
 
 ReplaySubject 会发射所有来自原始Observable的数据给观察者，无论它们是何时订阅的。当一个新的 observer 订阅了一个 ReplaySubject 之后，他将会收到当前缓存在 buffer 中的数据和这之后产生的新数据。在下面的例子中，缓存大小为 1 所以 observer 将最多能够收到订阅时间点之前的一个数据。例如， Subscription: 2 能够收到消息 "b" ，而这个消息是在他订阅之前发送的，但是没有办法收到消息 "a" 因为缓存的容量小于 2 。
 ![](ReplaySubject.png)
*/
example("ReplaySubject") {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 ----
## BehaviorSubject
Broadcasts new events to all subscribers, and the most recent (or initial) value to new subscribers.
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)
 
 当观察者订阅 BehaviorSubject 时，它开始发射原始 Observable 最近发射的数据（如果此时还没有收到任何数据，它会发射一个默认值），然后继续发射其它任何来自原始Observable的数据。
 ![](Behaviorsubject1.png)
 
 ![](BehaviorSubject2.png)
 
*/
example("BehaviorSubject") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴")
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject.addObserver("3").addDisposableTo(disposeBag)
    subject.onNext("🍐")
    subject.onNext("🍊")
}
/*:
 > Notice what's missing in these previous examples? A Completed event. `PublishSubject`, `ReplaySubject`, and `BehaviorSubject` do not automatically emit Completed events when they are about to be disposed of.
 ----
 ## Variable
 Wraps a `BehaviorSubject`, so it will emit the most recent (or initial) value to new subscribers. And `Variable` also maintains current value state. `Variable` will never emit an Error event. However, it will automatically emit a Completed event and terminate on `deinit`.
 
 Variable 封装了 BehaviorSubject 。使用 variable 的好处是 variable 将不会显式的发送 Error 或者 Completed 。在 deallocated 的时候， Variable 会自动的发送 complete 事件。
 
*/
example("Variable") {
    let disposeBag = DisposeBag()
    let variable = Variable("🔴")
    
    variable.asObservable().addObserver("1").addDisposableTo(disposeBag)
    variable.value = "🐶"
    variable.value = "🐱"
    
    variable.asObservable().addObserver("2").addDisposableTo(disposeBag)
    variable.value = "🅰️"
    variable.value = "🅱️"
}
//:  > Call `asObservable()` on a `Variable` instance in order to access its underlying `BehaviorSubject` sequence. `Variable`s do not implement the `on` operator (or, e.g., `onNext(_:)`), but instead expose a `value` property that can be used to get the current value, and also set a new value. Setting a new value will also add that value onto its underlying `BehaviorSubject` sequence.

//: [Next](@next) - [Table of Contents](Table_of_Contents)
