//
//  AppDelegate-openglcb.m
//  mpv-examples
//
//  Created by pengyucheng on 16/6/24.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "AppDelegate-openglcb.h"
#import "PlayerLoader.h"

static inline void check_error(int status)
{
    if (status < 0) {
        printf("mpv API error: %s\n", mpv_error_string(status));
        exit(1);
    }
}

static void *get_proc_address(void *ctx, const char *name)
{
    CFStringRef symbolName = CFStringCreateWithCString(kCFAllocatorDefault, name, kCFStringEncodingASCII);
    void *addr = CFBundleGetFunctionPointerForName(CFBundleGetBundleWithIdentifier(CFSTR("com.apple.opengl")), symbolName);
    CFRelease(symbolName);
    return addr;
}

static void glupdate(void *ctx);


@implementation MpvClientOGLView
- (instancetype)initWithFrame:(NSRect)frame
{
    // make sure the pixel format is double buffered so we can use
    // [[self openGLContext] flushBuffer].
    NSOpenGLPixelFormatAttribute attributes[] = {
        NSOpenGLPFADoubleBuffer,
        0
    };
    self = [super initWithFrame:frame
                    pixelFormat:[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes]];
    
    if (self) {
        [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        // swap on vsyncs
        GLint swapInt = 1;
        [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
        [[self openGLContext] makeCurrentContext];
        self.mpvGL = nil;
    }
    return self;
}

- (void)fillBlack
{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)drawRect
{
    if (self.mpvGL)
        mpv_opengl_cb_draw(self.mpvGL, 0, self.bounds.size.width, -self.bounds.size.height);
    else
        [self fillBlack];
    [[self openGLContext] flushBuffer];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawRect];
}
@end

@implementation CocoaWindow
- (BOOL)canBecomeMainWindow { return YES; }
- (BOOL)canBecomeKeyWindow { return YES; }
- (void)initOGLView {
    NSRect bounds = [[self contentView] bounds];
    // window coordinate origin is bottom left
    NSRect glFrame = NSMakeRect(bounds.origin.x, bounds.origin.y + 30, bounds.size.width, bounds.size.height - 30);
    _glView = [[MpvClientOGLView alloc] initWithFrame:glFrame];
    [self.contentView addSubview:_glView];
    
    NSRect buttonFrame = NSMakeRect(bounds.origin.x, bounds.origin.y, 60, 30);
    _pauseButton = [[NSButton alloc] initWithFrame:buttonFrame];
    _pauseButton.buttonType = NSToggleButton;
    // button target has to be the delegate (it holds the mpv context
    // pointer), so that's set later.
    _pauseButton.action = @selector(togglePause:);
    _pauseButton.title = @"Pause";
    _pauseButton.alternateTitle = @"Play";
    [self.contentView addSubview:_pauseButton];
}
@end


static void wakeup(void *);


@implementation AppDelegate_openglcb

- (void)createWindow {
    
    int mask = NSTitledWindowMask|NSClosableWindowMask|
    NSMiniaturizableWindowMask|NSResizableWindowMask;
    
    window = [[CocoaWindow alloc]
              initWithContentRect:NSMakeRect(0, 0, 1280, 720)
              styleMask:mask
              backing:NSBackingStoreBuffered
              defer:NO];
    
    // force a minimum size to stop opengl from exploding.
    [window setMinSize:NSMakeSize(200, 200)];
    [window initOGLView];
    [window setTitle:@"cocoa-openglcb example"];
    [window makeMainWindow];
    [window makeKeyAndOrderFront:nil];
    
    NSMenu *m = [[NSMenu alloc] initWithTitle:@"AMainMenu"];
    NSMenuItem *item = [m addItemWithTitle:@"Apple" action:nil keyEquivalent:@""];
    NSMenu *sm = [[NSMenu alloc] initWithTitle:@"Apple"];
    [m setSubmenu:sm forItem:item];
    [sm addItemWithTitle: @"quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [NSApp setMenu:m];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    atexit_b(^{
        // Because activation policy has just been set to behave like a real
        // application, that policy must be reset on exit to prevent, among
        // other things, the menubar created here from remaining on screen.
        [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    });
    
    [self createWindow];
    window.pauseButton.target = self;
    
    mpv = mpv_create();
    if (!mpv) {
        printf("failed creating context\n");
        exit(1);
    }
    check_error(mpv_set_option_string(mpv, "input-media-keys", "yes"));
    // request important errors
    check_error(mpv_request_log_messages(mpv, "warn"));
    
    check_error(mpv_initialize(mpv));
    check_error(mpv_set_option_string(mpv, "vo", "opengl-cb"));
    
    mpv_opengl_cb_context *mpvGL = mpv_get_sub_api(self->mpv, MPV_SUB_API_OPENGL_CB);
    if (!mpvGL) {
        puts("libmpv does not have the opengl-cb sub-API.");
        exit(1);
    }
    // pass the mpvGL context to our view
    window.glView.mpvGL = mpvGL;
    int r = mpv_opengl_cb_init_gl(window.glView.mpvGL, NULL, get_proc_address, NULL);
    if (r < 0) {
        puts("gl init has failed.");
        exit(1);
    }
    mpv_opengl_cb_set_update_callback(window.glView.mpvGL, glupdate, (__bridge void *)window.glView);
    
    // Deal with MPV in the background.
    queue = dispatch_queue_create("mpv", DISPATCH_QUEUE_SERIAL);
    
    [self openfileVideo:@"/Users/pengyucheng/Desktop/d.mp4"];
}

static void glupdate(void *ctx)
{
    MpvClientOGLView *glView = (__bridge MpvClientOGLView *)ctx;
    // I'm still not sure what the best way to handle this is, but this
    // works.
    dispatch_async(dispatch_get_main_queue(), ^{
        [glView drawRect];
    });
}

- (void) handleEvent:(mpv_event *)event
{
    switch (event->event_id) {
        case MPV_EVENT_SHUTDOWN: {
            mpv_detach_destroy(mpv);
            mpv_opengl_cb_uninit_gl(window.glView.mpvGL);
            mpv = NULL;
            printf("event: shutdown\n");
            break;
        }
            
        case MPV_EVENT_LOG_MESSAGE: {
            struct mpv_event_log_message *msg = (struct mpv_event_log_message *)event->data;
            printf("[%s] %s: %s", msg->prefix, msg->level, msg->text);
        }
            
        default:
            printf("event: %s\n", mpv_event_name(event->event_id));
    }
}

- (void)togglePause:(NSButton *)button
{
    if (mpv) {
        switch (button.state) {
            case NSOffState:
            {
                int pause = 0;
                mpv_set_property(mpv, "pause", MPV_FORMAT_FLAG, &pause);
            }
                break;
            case NSOnState:
            {
                int pause = 1;
                mpv_set_property(mpv, "pause", MPV_FORMAT_FLAG, &pause);
            }
                break;
            default:
                NSLog(@"This should never happen.");
        }
    }
}

- (void) readEvents
{
    dispatch_async(queue, ^{
        while (mpv) {
            mpv_event *event = mpv_wait_event(mpv, 0);
            if (event->event_id == MPV_EVENT_NONE)
                break;
            [self handleEvent:event];
        }
    });
}

static void wakeup(void *context)
{
    AppDelegate_openglcb *a = (__bridge AppDelegate_openglcb *) context;
    [a readEvents];
}

-(void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames
{
    //bilibi播放器
    [[PlayerLoader sharedInstance] loadVideoWithLocalFiles:filenames];
    NSLog(@"Handle open files: %@",filenames);
}
//
-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    //bilibili
    [[PlayerLoader sharedInstance] loadVideoWithLocalFiles:@[filename]];
    NSLog(@"Handle open files: %@",@[filename]);
    return YES;
    
    // Read filename
    if(mpv){
        [self openfileVideo:filename];
        return YES;
    }else{
        return NO;
    }
    
}

-(void)openfileVideo:(NSString*)fileName{
    // Read filename
    NSArray *args = [NSProcessInfo processInfo].arguments;
//    if (args.count < 2) {
//        NSLog(@"Expected filename on command line");
//        exit(1);
//    }
    NSString *filename = fileName;
    dispatch_async(queue, ^{
        // Register to be woken up whenever mpv generates new events.
        mpv_set_wakeup_callback(mpv, wakeup, (__bridge void *)self);
        // Load the indicated file
        const char *cmd[] = {"loadfile", filename.UTF8String, NULL};
        check_error(mpv_command(mpv, cmd));
    });
}

// quit when the window is closed.
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSLog(@"Terminating.");
    const char *args[] = {"quit", NULL};
    mpv_command(mpv, args);
    [window.glView clearGLContext];
    return NSTerminateNow;
}

@end
