//
//  AppDelegate.h
//  mpv-examples
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "client.h"

#include <stdio.h>
#include <stdlib.h>
@interface AppDelegate_cocoabasic : NSObject <NSApplicationDelegate>
{
    mpv_handle *mpv;
    dispatch_queue_t queue;
    NSWindow *w;
    NSView *wrapper;
}


@end

