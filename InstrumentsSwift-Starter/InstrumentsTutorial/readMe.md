[原路径](https://www.raywenderlich.com/97886/instruments-tutorial-with-swift-getting-started)
 This sample app uses the Flickr API to search for images. To use the API you’ll need an API key. For demo projects, you can generate a sample key on Flickr’s website. Just perform any search at: http://www.flickr.com/services/api/explore/?method=flickr.photos.search and copy the API key out of the URL at the bottom – it follows the “&api_key=” all the way to the next “&”.
 For example, if the URL is:
 ```
 http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=6593783 efea8e7f6dfc6b70bc03d2afb&format=rest&api_sig=f24f4e98063a9b8ecc8b522b238d5e2f
 ```
 `
 Then the API key is: 6593783efea8e7f6dfc6b70bc03d2afb.
 Paste it into the top of the FlickrSearcher.swift file, replacing the existing API key.
 
Automate UI Testing in iOS
    This chapter describes how you use the Automation template in Instruments to execute scripts. 
 The Automation instrument provides powerful features, including:
 1. Script editing with a built-in script editor
 2. Capturing (recording) user interface actions for use in automation scripts
 3. Running a test script from an Xcode project
 4. Powerful API features, including the ability to simulate a device location change and to execute a task from the Automation instrument on the host
 
 Load Saved Automation Test Scripts:
    
 
 UI Automation JavaScript Reference for iOS
    Recording Results With the Log
 For example:
     To indicate the initiation of a specified test, use the logStart method:
     UIALogger.logStart("Test1");
     
     To end a test and mark it as failed, use the logFail method:
     UIALogger.logFail("Failed to foo.");
     
     To send a general-purpose debug message, use the logDebug method:
     UIALogger.logDebug("Done with level 3.");
     
     You view the collected data in the Detail pane of the Automation instrument using Instruments.
 
 Access and Manipulate UI Elements:
 
   1. Understand the Element Hierarchy:
 2. Simplify Element Hierarchy Navigation:
    
