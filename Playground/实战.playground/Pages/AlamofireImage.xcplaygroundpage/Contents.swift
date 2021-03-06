//: [Previous](@previous)

import UIKit
import Alamofire
import AlamofireImage
import XCPlayground

//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

var str = "Hello, playground"

//: [Next](@next)

let image1 = [#Image(imageLiteral: "london-thumb@3x.jpg")#]
let radius: CGFloat = 20.0

let roundedImage = image1.af_imageWithRoundedCornerRadius(radius)
let circularImage = image1.af_imageRoundedIntoCircle()

let imgView = UIImageView(image: image1)
imgView.backgroundColor = UIColor.redColor()
XCPlaygroundPage.currentPage.liveView = imgView
XCPlaygroundPage.currentPage.captureValue(circularImage, withIdentifier: "tyyy12333")



let image = [#Image(imageLiteral: "london-thumb@3x.jpg")#]



let size = CGSize(width: 100.0, height: 100.0)

// Scale image to size disregarding aspect ratio
let scaledImage = image.af_imageScaledToSize(size)
XCPlaygroundPage.currentPage.captureValue(scaledImage, withIdentifier: "scoledimage")
// Scale image to fit within specified size while maintaining aspect ratio
let aspectScaledToFitImage = image.af_imageAspectScaledToFitSize(size)
XCPlaygroundPage.currentPage.captureValue(aspectScaledToFitImage, withIdentifier: "aspectScaledToFitImage")
// Scale image to fill specified size while maintaining aspect ratio
let aspectScaledToFillImage = image.af_imageAspectScaledToFillSize(size)

XCPlaygroundPage.currentPage.captureValue(aspectScaledToFillImage, withIdentifier: "aspectScaledToFillImage")
