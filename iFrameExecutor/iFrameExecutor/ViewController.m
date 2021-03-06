//
//  ViewController.m
//  iFrameExecutor
//
//  Created by pengyucheng on 16/6/17.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "ViewController.h"
#import "Utilities.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"initialize VideoFrameExtractor...");
    NSString *videoPath = [Utilities bundlePath:@"for_the_birds.avi"];
    NSBundle *bundle = [NSBundle mainBundle];
    videoPath = [bundle pathForResource:@"for_the_birds" ofType:@"avi"];
//    videoPath = [bundle pathForResource:@"1.mp4" ofType:@"pbb"];
//    videoPath = @"/Users/pengyucheng/Desktop/3V7.8.0.mp4";
    NSLog(@"read video path: %@", videoPath);
    
    self.video = [[VideoFrameExtractor alloc] initWithVideo:videoPath];
    DLog(@"success.");
    
    DLog(@"setting video exetractor size....");

    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"video duration: %f", self.video.duration);
    NSLog(@"video size: %d x %d", self.video.sourceWidth, self.video.sourceHeight);
        self.video.outputWidth = self.video.sourceWidth;
        self.video.outputHeight = self.video.sourceHeight;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)playClicked:(id)sender {
    DLog(@"play clicked... playing....");
    [_playButton setEnabled:NO];
    lastFrameTime = -1;
    
    // seek to 0.0 seconds
    [_video seekTime:0.0];
    
    //	float nFrame = 1.0/10;
    // 帧数
    // N 制: 中国使用, 每秒25帧
    // Pal 制: 国外使用, 每秒30帧
    float palFrame = 1.0/30; // PAL Mode
    
    [NSTimer scheduledTimerWithTimeInterval:palFrame
                                     target:self
                                   selector:@selector(displayNextFrame:)
                                   userInfo:nil
                                    repeats:YES];
}

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    
    if (![_video stepFrame]) {
        [timer invalidate];
        [_playButton setEnabled:YES];
        return;
    }
    
    _videoView.image = _video.currentImage;
    
    float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
    if (lastFrameTime<0) {
        lastFrameTime = frameTime;
    } else {
        lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
    }
    [_label setStringValue:[NSString stringWithFormat:@"%.0f",lastFrameTime]];
}
@end
