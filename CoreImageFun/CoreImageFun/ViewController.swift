//
//  ViewController.swift
//  CoreImageFun
//
//  Created by Alexis Gallagher on 2014-07-16.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                            
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var amountSlider: UISlider!
  
  var context: CIContext!
  var filter: CIFilter!
  var beginImage: CIImage!
  var orientation: UIImageOrientation = .Up //New
  
  @IBAction func amountSliderValueChanged(sender: UISlider) {
    let sliderValue = sender.value
    //Get the output CIImage from the CIFilter.
    let outputImage = self.oldPhoto(beginImage, withAmount: sliderValue)
    //Convert the CIImage to a CGImage.
    let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent())
    
    //onvert the CGImage to a UIImage, and display it in the image view.
    let newImage = UIImage(CGImage: cgimg, scale:1, orientation:orientation)
    self.imageView.image = newImage
  }
  
  @IBAction func loadPhoto(sender: AnyObject) {
    let pickerC = UIImagePickerController()
    pickerC.delegate = self
    self.presentViewController(pickerC, animated: true, completion: nil)
  }
  
  @IBAction func savePhoto(sender: AnyObject) {
    // 1
    let imageToSave = filter.outputImage
    
    // 2
    let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
    
    // 3
    let cgimg = softwareContext.createCGImage(imageToSave, fromRect:imageToSave.extent())
    
    // 4
    let library = ALAssetsLibrary()
    library.writeImageToSavedPhotosAlbum(cgimg,
      metadata:imageToSave.properties(),
      completionBlock:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 1 creates an NSURL object that holds the path to your image file.
    let fileURL = NSBundle.mainBundle().URLForResource("image", withExtension: "png")
    
    // 2 Next you create your CIImage with the CIImage(contentsOfURL:) constructor
    beginImage = CIImage(contentsOfURL: fileURL)
    
    // 3 create CISepiaTone filter. The CIFilter constructor takes the name of the filter
    filter = CIFilter(name: "CISepiaTone")
    //the KCIInputImageKey (a CIImage)
    filter.setValue(beginImage, forKey: kCIInputImageKey)
    //the kCIInputIntensityKey, a float value between 0 and 1. Here you give that value 0.5.
    filter.setValue(0.5, forKey: kCIInputIntensityKey)
    let outputImage = filter.outputImage
    
    // 1 The CIContext(options:) constructor takes an NSDictionary that specifies options such as the color format, or whether the context should run on the CPU or GPU
    context = CIContext(options:nil)
    //Calling createCGImage(outputImage:fromRect:) on the context with the supplied CIImage will return a new CGImage instance
    let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent())
    
    // 2 Note that there is no need to explicitly release the CGImage after we are finished with it, as there would have been in Objective-C. In Swift, ARC can automatically release Core Foundation objects.
    let newImage = UIImage(CGImage: cgimg)
    self.imageView.image = newImage
    
    self.logAllFilters()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
 
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
    self.dismissViewControllerAnimated(true, completion: nil);
    
    let gotImage = info[UIImagePickerControllerOriginalImage] as UIImage
    
    beginImage = CIImage(image:gotImage)
    orientation = gotImage.imageOrientation
    filter.setValue(beginImage, forKey: kCIInputImageKey)
    self.amountSliderValueChanged(amountSlider)
  }
  
  func logAllFilters() {
    
    let properties = CIFilter.filterNamesInCategory(
      kCICategoryBuiltIn)
    println(properties)
    
    for filterName: AnyObject in properties {
      let fltr = CIFilter(name:filterName as String)
      println(fltr.attributes())
    }
  }
  
  func oldPhoto(img: CIImage, withAmount intensity: Float) -> CIImage {
    
    // 1
    let sepia = CIFilter(name:"CISepiaTone")
    sepia.setValue(img, forKey:kCIInputImageKey)
    sepia.setValue(intensity, forKey:"inputIntensity")
    
    // 2
    let random = CIFilter(name:"CIRandomGenerator")
    
    // 3
    let lighten = CIFilter(name:"CIColorControls")
    lighten.setValue(random.outputImage, forKey:kCIInputImageKey)
    lighten.setValue(1 - intensity, forKey:"inputBrightness")
    lighten.setValue(0, forKey:"inputSaturation")
    
    // 4
    let croppedImage = lighten.outputImage.imageByCroppingToRect(beginImage.extent())
    
    // 5
    let composite = CIFilter(name:"CIHardLightBlendMode")
    composite.setValue(sepia.outputImage, forKey:kCIInputImageKey)
    composite.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)
    
    // 6
    let vignette = CIFilter(name:"CIVignette")
    vignette.setValue(composite.outputImage, forKey:kCIInputImageKey)
    vignette.setValue(intensity * 2, forKey:"inputIntensity")
    vignette.setValue(intensity * 30, forKey:"inputRadius")
    
    // 7
    return vignette.outputImage
  }
  
  
  
}

