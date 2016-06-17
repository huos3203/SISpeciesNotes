//
//  ViewController.h
//  ffmpegc-demo
//
//  Created by pengyucheng on 16/6/17.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoFrameExtractor.h"

@interface ViewController : UIViewController {
    float lastFrameTime;
}

@property(strong, nonatomic) IBOutlet UIImageView *videoView;
@property(strong, nonatomic) IBOutlet UILabel *label;

@property(strong, nonatomic) IBOutlet UIBarButtonItem *playButton;


@property (nonatomic, strong) VideoFrameExtractor *video;

-(IBAction)playClicked:(id)sender;


@end
