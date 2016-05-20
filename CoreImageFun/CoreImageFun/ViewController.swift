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
    let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent)
    
    //convert the CGImage to a UIImage, and display it in the image view.
    let newImage = UIImage(CGImage: cgimg, scale:1, orientation:orientation)
    self.imageView.image = newImage
  }
  
  @IBAction func loadPhoto(sender: AnyObject) {
    let pickerC = UIImagePickerController()
    pickerC.delegate = self
    self.presentViewController(pickerC, animated: true, completion: nil)
  }
  
  @IBAction func savePhoto(sender: AnyObject) {
    // 1 Get the CIImage output from the filter.
    let imageToSave = filter.outputImage
    
    // 2 Create a new, software based CIContext that uses the CPU renderer.
    //Note that the software renderer won’t work properly in the simulator.
    let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
    
    // 3 Generate the CGImage.
    let cgimg = softwareContext.createCGImage(imageToSave!, fromRect:imageToSave!.extent)
    
    // 4 Save the CGImage to the photo library.
    let library = ALAssetsLibrary()
    library.writeImageToSavedPhotosAlbum(cgimg,
      metadata:imageToSave!.properties,
      completionBlock:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 1 creates an NSURL object that holds the path to your image file.
    let fileURL = NSBundle.mainBundle().URLForResource("image", withExtension: "png")
    
    // 2 Next you create your CIImage with the CIImage(contentsOfURL:) constructor
    beginImage = CIImage(contentsOfURL: fileURL!)
    
    // 3 create CISepiaTone filter. The CIFilter constructor takes the name of the filter
    filter = CIFilter(name: "CISepiaTone")
    //the KCIInputImageKey (a CIImage)
    filter.setValue(beginImage, forKey: kCIInputImageKey)
    //the kCIInputIntensityKey, a float value between 0 and 1. Here you give that value 0.5.
    filter.setValue(0.5, forKey: kCIInputIntensityKey)
    let outputImage = filter.outputImage
    
    // 1 The CIContext(options:) constructor takes an NSDictionary that specifies options such as the color format, or whether the context should run on the CPU or GPU, The default behavior is to use the GPU because it’s much faster, and you don’t want to slow down the filtering performance for the sake of adding save functionality.
    //This could be a problem, as the GPU stops whatever it’s doing when you switch from one app to another. If the photo hasn’t finished saving, it won’t be there when you go looking for it later!
    context = CIContext(options:nil)
    //Calling createCGImage(outputImage:fromRect:) on the context with the supplied CIImage will return a new CGImage instance
    let cgimg = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
    
    // 2 Note that there is no need to explicitly release the CGImage after we are finished with it, as there would have been in Objective-C. In Swift, ARC can automatically release Core Foundation objects.
    let newImage = UIImage(CGImage: cgimg)
    self.imageView.image = newImage
    
    self.logAllFilters()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
 
    //https://github.com/foundry/UIImageMetadata
    // Image files taken on mobile phones have a variety of data associated with them, such as GPS coordinates, image format, and orientation
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        beginImage = CIImage(image:gotImage)
        orientation = gotImage.imageOrientation
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        self.amountSliderValueChanged(amountSlider)
    }

  
  func logAllFilters() {
    //CIFilter API has more than 126 filters of which are available on iOS 8 ,
    //This method will return an array of filter names
    let properties = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
    print(properties)
    
    //each filter has an attributes() method that will return a dictionary containing information about that filter,This information includes the filter’s name and category, the kinds of inputs the filter takes, and the default and acceptable values for those inputs.
    for filterName: AnyObject in properties {
      let fltr = CIFilter(name:filterName as! String)
      print(fltr!.attributes)
    }
  }
  
    //仿古滤镜：It will take a CIImage, filter it to look like an old aged photo, and return a modified CIImage.
  func oldPhoto(img: CIImage, withAmount intensity: Float) -> CIImage {
    
    // 1 Set up the sepia filter the same way you did in the simpler scenario. You’re passing in a Float value in the method to set the intensity of the sepia effect. This value will be provided by the slider
    let sepia = CIFilter(name:"CISepiaTone")
    sepia!.setValue(img, forKey:kCIInputImageKey)
    sepia!.setValue(intensity, forKey:"inputIntensity")
    
    // 2 Set up a filter that creates a random noise pattern that looks like this:
    let random = CIFilter(name:"CIRandomGenerator")
    
    // 3 Alter the output of the random noise generator.
    let lighten = CIFilter(name:"CIColorControls")
    lighten!.setValue(random!.outputImage, forKey:kCIInputImageKey)
    lighten!.setValue(1 - intensity, forKey:"inputBrightness")
    lighten!.setValue(0, forKey:"inputSaturation")
    
    // 4 takes an output CIImage and crops it to the provided rect.
    let croppedImage = lighten!.outputImage!.imageByCroppingToRect(beginImage.extent)
    
    // 5 Combine the output of the sepia filter with the output of the CIRandomGenerator filter
    //Most (if not all) of the filter options in photoshop are achievable using Core Image.
    let composite = CIFilter(name:"CIHardLightBlendMode")
    composite!.setValue(sepia!.outputImage, forKey:kCIInputImageKey)
    composite!.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)
    
    // 6 Run a vignette filter on this composited output that darkens the edges of the photo. You’re using the value from the slider to set the radius and intensity of this effect.
    let vignette = CIFilter(name:"CIVignette")
    vignette!.setValue(composite!.outputImage, forKey:kCIInputImageKey)
    vignette!.setValue(intensity * 2, forKey:"inputIntensity")
    vignette!.setValue(intensity * 30, forKey:"inputRadius")
    
    // 7 Finally, return the output of the last filter.
    return vignette!.outputImage!
  }
}

