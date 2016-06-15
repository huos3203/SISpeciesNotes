//
//  main.m
//  OpenWithMPV
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[]) {
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, argv);
}
