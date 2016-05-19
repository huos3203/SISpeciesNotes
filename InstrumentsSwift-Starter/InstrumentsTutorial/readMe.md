[原路径](https://www.raywenderlich.com/97886/instruments-tutorial-with-swift-getting-started)

 
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
    