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
# Combination Operators
Operators that combine multiple source `Observable`s into a single `Observable`.
## `startWith`
Emits the specified sequence of elements before beginning to emit the elements from the source `Observable`. [More info](http://reactivex.io/documentation/operators/startwith.html)
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/startwith.png)
 
 在数据序列的开头增加一些数据
 ![](startWith.png)
*/
example("startWith") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .startWith("1️⃣")
        .startWith("2️⃣")
        .startWith("3️⃣", "🅰️", "🅱️")
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 > As this example demonstrates, `startWith` can be chained on a last-in-first-out basis, i.e., each successive `startWith`'s elements will be prepended before the prior `startWith`'s elements.
 ----
 ## `merge`
 Combines elements from source `Observable` sequences into a single new `Observable` sequence, and will emit each element as it is emitted by each source `Observable` sequence. [More info](http://reactivex.io/documentation/operators/merge.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/merge.png)
 
 合并多个 Observables 的组合成一个
 ![](merge.png)
 */
example("merge") {
    let disposeBag = DisposeBag()
    
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()
    
    Observable.of(subject1, subject2)
        .merge()
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    
    subject1.onNext("🅰️")
    
    subject1.onNext("🅱️")
    
    subject2.onNext("①")
    
    subject2.onNext("②")
    
    subject1.onNext("🆎")
    
    subject2.onNext("③")
}
/*:
 ----
 ## `zip`
 Combines up to 8 source `Observable` sequences into a single new `Observable` sequence, and will emit from the combined `Observable` sequence the elements from each of the source `Observable` sequences at the corresponding index. [More info](http://reactivex.io/documentation/operators/zip.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/zip.png)
 
 使用一个函数组合多个Observable发射的数据集合，然后再发射这个结果(从序列中依次取数据)
 ![](zip.png)
 */
example("zip") {
    let disposeBag = DisposeBag()
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.zip(stringSubject, intSubject) { stringElement, intElement in
        "\(stringElement) \(intElement)"
        }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    
    stringSubject.onNext("🅰️")
    stringSubject.onNext("🅱️")
    
    intSubject.onNext(1)
    
    intSubject.onNext(2)
    
    stringSubject.onNext("🆎")
    intSubject.onNext(3)
}
/*:
 ----
 ## `combineLatest`
 Combines up to 8 source `Observable` sequences into a single new `Observable` sequence, and will begin emitting from the combined `Observable` sequence the latest elements of each source `Observable` sequence once all source sequences have emitted at least one element, and also when any of the source `Observable` sequences emits a new element. [More info](http://reactivex.io/documentation/operators/combinelatest.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/combinelatest.png)
 
 当两个 Observables 中的任何一个发射了一个数据时，通过一个指定的函数组合每个Observable发射的最新数据（一共两个数据），然后发射这个函数的结果
 ![](combineLatest.png)
 */
example("combineLatest") {
    let disposeBag = DisposeBag()
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
        }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    
    stringSubject.onNext("🅰️")
    
    stringSubject.onNext("🅱️")
    intSubject.onNext(1)
    
    intSubject.onNext(2)
    
    stringSubject.onNext("🆎")
}
//: There is also a `combineLatest` extension on `Array`:
example("Array.combineLatest") {
    let disposeBag = DisposeBag()
    
    let stringObservable = Observable.just("❤️")
    let fruitObservable = ["🍎", "🍐", "🍊"].toObservable()
    let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
    
    [stringObservable, fruitObservable, animalObservable].combineLatest {
            "\($0[0]) \($0[1]) \($0[2])"
        }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
/*:
 > The `combineLatest` extension on `Array` requires that all source `Observable` sequences are of the same type.
 ----
 ## `switchLatest`
 Transforms the elements emitted by an `Observable` sequence into `Observable` sequences, and emits elements from the most recent inner `Observable` sequence. [More info](http://reactivex.io/documentation/operators/switch.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/switch.png)
 
 将一个发射多个 Observables 的 Observable 转换成另一个单独的 Observable，后者发射那些 Observables 最近发射的数据项
 
 Switch 订阅一个发射多个 Observables 的 Observable。它每次观察那些 Observables 中的一个，Switch 返回的这个Observable取消订阅前一个发射数据的 Observable，开始发射最近的Observable 发射的数据。注意：当原始 Observable 发射了一个新的 Observable 时（不是这个新的 Observable 发射了一条数据时），它将取消订阅之前的那个 Observable。这意味着，在后来那个 Observable 产生之后到它开始发射数据之前的这段时间里，前一个 Observable 发射的数据将被丢弃
 ![](switchLatest.png)
 */
example("switchLatest") {
    let disposeBag = DisposeBag()
    
    let subject1 = BehaviorSubject(value: "⚽️")
    let subject2 = BehaviorSubject(value: "🍎")
    
    let variable = Variable(subject1)
        
    variable.asObservable()
        .switchLatest()
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    
    subject1.onNext("🏈")
    subject1.onNext("🏀")
    
    variable.value = subject2
    
    subject1.onNext("⚾️")
    
    subject2.onNext("🍐")
}
/*:
 > In this example, adding ⚾️ onto `subject1` after setting `variable.value` to `subject2` has no effect, because only the most recent inner `Observable` sequence (`subject2`) will emit elements.
 */

//: [Next](@next) - [Table of Contents](Table_of_Contents)
