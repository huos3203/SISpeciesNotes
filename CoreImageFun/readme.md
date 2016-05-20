[Core Image Tutorial: Getting Started](https://www.raywenderlich.com/76285/beginning-core-image-swift )
 Basic Image Filtering
 You’re going to get started by simply running your image through a CIFilter and displaying it on the screen. Every time you want to apply a CIFilter to an image you need to do four things:
 
 1. Create a CIImage object. CIImage has several initialization methods, including: CIImage(contentsOfURL:), CIImage(data:), CIImage(CGImage:), CIImage(bitmapData:bytesPerRow:size:format:colorSpace:), and several others. You’ll most likely be working with CIImage(contentsOfURL:) most of the time.
 
 2. Create a CIContext. A CIContext can be CPU or GPU based. A CIContext is relatively expensive to initialize so you reuse it rather than create it over and over. You will always need one when outputting the CIImage object.
 
 3. Create a CIFilter. When you create the filter, you configure a number of properties on it that depend on the filter you’re using.
 
 4. Get the filter output. The filter gives you an output image as a CIImage – you can convert this to a UIImage using the CIContext, as you’ll see below.