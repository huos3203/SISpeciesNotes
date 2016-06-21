//
//  ViewController.h
//  iFrameExecutor
//
//  Created by pengyucheng on 16/6/17.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoFrameExtractor.h"

@interface ViewController : NSViewController{
    float lastFrameTime;
}

@property(strong, nonatomic) IBOutlet NSImageView *videoView;
//@property(strong, nonatomic) IBOutlet NSLabel *label;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSTextField *label;

//@property(strong, nonatomic) IBOutlet NSBarButtonItem *playButton;


@property (nonatomic, strong) VideoFrameExtractor *video;

-(IBAction)playClicked:(id)sender;


@end

