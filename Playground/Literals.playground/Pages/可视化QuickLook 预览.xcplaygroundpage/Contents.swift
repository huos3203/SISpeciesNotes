/*: 
[字面量](@previous)
### [可视化XCPCaptureValue](http://swifter.tips/playground-capture/)
简介：可以多次调用该方法来做图，相同的 identifier 的数据将会出现在同一张图上，而 value 将根据输入的次序进行排列,将一组数据轻而易举地绘制到时间轴上，从而让我们能看到每一步的结果。这不仅对我们直观且及时地了解算法内部的变化很有帮助，也会是教学或者演示时候的神兵利器。
1. 使用：导入框架`import XCPlayground`
2. 扩展：XCPCaptureValue 的数据输入是任意类型的，所以不论是传什么进去都是可以表示的。它们将以 QuickLook 预览的方式被表现出来，一些像 UIImage，UIColor 或者 UIBezierPath 这样的类型已经实现了 QuickLook。当然对于那些没有实现快速预览的 NSObject 子类，也可以通过重写  

[Next](@next)
*/


//:3. 举例冒泡排序，我们在每一轮排序完成后使用 plot 方法将当前的数组状态用 XCPCaptureValue 的方式进行了输出。通过在时间轴 (通过 “Alt+Cmd+回车” 打开 Assistant Editor) 的输出图，我们就可以非常清楚地了解到整个算法的执行过程了。
import Foundation
import XCPlayground



var arr = [14, 11, 20, 1, 3, 9, 4, 15, 6, 19,
    2, 8, 7, 17, 12, 5, 10, 13, 18, 16]

func plot<T>(title: String, array: [T]) {
    for value in array {
        XCPCaptureValue(title, value: value)
    }
}

plot("起始", array: arr)

func swap(inout x: Int, inout y: Int) {
    (x, y) = (y, x)
}

func bubbleSort<T: Comparable>(inout input: [T]) {
    for var i = input.count; i > 1; i-- {
        var didSwap = false
        for var j = 0; j < i - 1; j++ {
            if input[j] > input[j + 1] {
                didSwap = true
                swap(&input[j], &input[j + 1])
            }
        }
        if !didSwap {
            break
        }
        plot("第 \(input.count - (i - 1)) 次迭代", array: input)
    }
    plot("结果", array: input)
}

bubbleSort(&arr)









