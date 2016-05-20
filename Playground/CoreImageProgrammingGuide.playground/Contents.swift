//: Playground - noun: a place where people can play

import UIKit

/*
 一、介绍
 Core Image是一个处理和分析图像的技术，被设计用来提供接近实时处理静态和视频图像。Core Image隐藏了低级的graphics 处理过程，提供了一个易于使用的程序界面（API）。你不需要知道OpenGL ES的细节，也不需要知道GCD。它替你处理这些。
 1、Core Image 框架提供：

 1）访问内置的图像处理filter:
    filter有一打多的categories。一些被设计用来获得艺术的效果，例如stylize和halfone filter categories。另一些被设计用来优化修正图像问题，例如color adjustment 和 sharpen filters 。

 2）检测特征能力:
    Core Image可以识别静止图像的人脸特征，并且可以在视频图像中追踪它们。知道脸在什么位置，你可以决定在什么地方应用filter。
 
 3）支持自动图像增强:
    Core Image可以分析一幅图像的质量，并提供了一系列filter来优化和调整这些，例如色度、对比度和色调等。
 
 4）连接多个filter来创建自己想要的效果:
    Core Image为iOS提供了超过90个内置filter，为OS X提供了超过120个的filter。你通过提供key-value对来设置filter的输入参数。filter的output可以作为另一个filter的input，这样就可以把多个filter连接起来，形成自己想要的效果。
 
 3、Core Image有内置的filter相关文档。你可以查询系统来找出哪些filter是可用的。然后，对于每个filter，你可以获得一个字典，其中包含它的属性，例如输入参数、默认参数值、最小和最大值、display name，等等。
 */


//----------------------------------
/*
 二、处理图像：
 Core Image有3个类来支持图像处理：
     1）CIFilter：表示一个效果，其至少有一个输入参数和产出一个output image。
     2）CIImage：不可变对象，表示一幅图像。你可以synthesize image data或从一个file提供或从另一个CIFilter对象的output提供。
     3）CIContext：从一个filter提供的对象，用于Core Image绘制结果。
 */

// 1创建一个CIContext对象
let context = CIContext.init(options: nil)

//仿古滤镜--------CISepiaTone---------------
// 2创建一个CIImage对象
let image = CIImage.init(image: [#Image(imageLiteral: "photo.jpg")#])
//let input2 = CoreImage.CIImage(image: [#Image(imageLiteral: "photo.jpg")#])
// 3 创建一个filter，并设置其输入参数
let filter = CIFilter.init(name: "CISepiaTone")
filter?.setValue(image, forKey: kCIInputImageKey)
filter?.setValue(NSNumber.init(float: 0.8), forKey: "InputIntensity")
// 4 获得output图像，其输出是一个如何处理图像的处方，并没有实际被渲染。
let result = filter?.valueForKey(kCIOutputImageKey)
// 5 渲染CIImage到CGImage。
let cgImage = context.createCGImage(result! as! CIImage, fromRect: (result?.extent)!)
UIImage(CGImage: cgImage)

//黑白滤镜 ----CIPhotoEffectTonal---
let filter2 = CIFilter(name:"CIPhotoEffectTonal")
filter2!.setValue(image, forKey: kCIInputImageKey)
let outputImage = filter2!.outputImage
let outImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
let returnImage = UIImage(CGImage: outImage)


/*
 1. 介绍
 2. 处理图像
 3. 检测图像人脸
 4. 自动增强图片特性
 5. 查询系统的filter
 6. Subclassing CIFilter：Recipes for Custom Effects
 7. 获得最好性能
 8. 使用FeedBack来处理图像
 9. 在你写一个自定义的filter之前，需要注意些什么？
 10. 创建自定义Filters
 11. 打包和加载Image Units
 */
