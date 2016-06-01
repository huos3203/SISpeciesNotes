//
//  MyViewController.h
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/6/1.
//  Copyright © 2016年 recomend. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "MyProtocol.h"
#import "MyDelegate.h"
#import "PycFile.h"
@interface MyViewController : NSViewController<dddProtocol,myyProtocol,PycFileDelegate>

@end
