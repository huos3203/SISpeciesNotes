//: [Previous](@previous)

import Foundation
import UIKit
//: Use the CIDetector class to find faces in an image

//Creating a face detector

let detContext = CIContext.init(options: nil)
let detOpts = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
let detector = CIDetector.init(ofType: CIDetectorTypeFace, context: detContext, options: detOpts)
let myImage = CIImage.init(image: [#Image(imageLiteral: "face_detection_2x.png")#])

//let orientation = myImage?.properties["kCGImagePropertyOrientation"]
//let opts = [CIDetectorImageOrientation:orientation!]
let features = detector.featuresInImage(myImage!, options: nil)


for f in features  {

    let ff:CIFaceFeature = f as! CIFaceFeature
    
    print(NSStringFromCGRect(f.bounds))
    if(ff.hasLeftEyePosition){
        print("Left eye = ", ff.leftEyePosition.x, ff.leftEyePosition.y)
    }
    
    if(ff.hasRightEyePosition){
        print("Right eye = ", ff.rightEyePosition.x, ff.rightEyePosition.y)
    }
    
    if(ff.hasMouthPosition){
        print("Mouth = ", ff.mouthPosition.x, ff.mouthPosition.y)
    }
}

//: [Next](@next)
