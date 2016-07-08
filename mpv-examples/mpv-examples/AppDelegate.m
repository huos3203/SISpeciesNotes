//
//  AppDelegate.m
//  iFrameExecutor
//
//  Created by pengyucheng on 16/6/17.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerLoader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames
{
    //bilibi播放器
    [[PlayerLoader sharedInstance] loadVideoWithLocalFiles:filenames];
    NSLog(@"Handle open files: %@",filenames);
}

@end
