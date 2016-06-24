//
//  AppDelegate-openglcb.h
//  mpv-examples
//
//  Created by pengyucheng on 16/6/24.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <client.h>
#import <opengl_cb.h>

#import <stdio.h>
#import <stdlib.h>
#import <OpenGL/gl.h>

#import <Cocoa/Cocoa.h>

@interface MpvClientOGLView : NSOpenGLView
@property mpv_opengl_cb_context *mpvGL;
- (instancetype)initWithFrame:(NSRect)frame;
- (void)drawRect;
- (void)fillBlack;
@end

@interface CocoaWindow : NSWindow
@property(retain, readonly) MpvClientOGLView *glView;
@property(retain, readonly) NSButton *pauseButton;
@end

@interface AppDelegate_openglcb : NSObject<NSApplicationDelegate>
{
    mpv_handle *mpv;
    dispatch_queue_t queue;
    CocoaWindow *window;
}


@end





