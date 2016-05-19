//[ 参考](https://gist.github.com/xslim/839512)

/*
 //To indicate the initiation of a specified test, use the logStart method:
 UIALogger.logStart("Test1");
 //To end a test and mark it as failed, use the logFail method:
 //UIALogger.logFail("Failed to foo.");
 //To send a general-purpose debug message, use the logDebug method:
 UIALogger.logDebug("Done with level 3.");
 
 //UIALogger.logWarning("Alert with title '" + title + "' encountered.");
 
 */

// List element hierarchy for the Unit Conversion screen
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var appWindow = app.mainWindow();

//the results are for the current screen—in this case, the Unit Conversion screen.
UIALogger.logStart("Logging Unit Conversion element tree …");
target.logElementTree();
UIALogger.logPass();

var tabBar = appWindow.tabBar();
tabBar.buttons()["Unit Conversion"].tap();

// Switch screen (mode) based on value of variable
var destinationScreen = "Recipes";
if (tabBar.selectedButton().name() != destinationScreen) {
    tabBar.buttons()[destinationScreen].tap();
}

UIALogger.logStart("Logging tabBar element tree …");
tabBar.logElementTree();
UIALogger.logPass();

// tapping the right button in the navigation bar, labeled with a plus sign (+), displays a new screen used to add a new recipe.
var navBar = app.navigationBar();
//进入添加新菜单页面
navBar.buttons()["Add"].tap();
//填写菜单名
var textField = appWindow.textFields()[0];
textField.setValue("中国菜");

UIALogger.logStart("Logging navBar element tree …");
navBar.logElementTree();
UIALogger.logPass();

//cancel返回
if(appWindow.textFields().firstWithPredicate("name beginswith '中国菜'")){
    //保存
    UIALogger.logDebug("Save...");
    navBar.buttons()["Save"].tap();
}else{
    UIALogger.logDebug("Cancel....");
    navBar.buttons()["Cancel"].tap();
}

