//
//  AppDelegateHelper.h
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/6/2.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PycFile.h"
@interface AppDelegateHelper : NSObject<PycFileDelegate>

-(BOOL)openURLOfPycFileByLaunchedApp:(NSURL*)openURL;


@end
