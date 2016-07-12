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

@property(nonatomic,strong)NSString *phoneNo;
@property(nonatomic,strong)NSString *messageID;
@property(nonatomic,assign)NSInteger openedNum;

-(BOOL)openURLOfPycFileByLaunchedApp:(NSString*)openURL;

-(BOOL)getVerificationCodeByPhone:(NSString *)phone userPhone:(BOOL)userPhone;
@end
