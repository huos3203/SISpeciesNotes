//
//  AppDelegateHelper.h
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/6/2.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PycFile.h"
#import "Singleton.h"

@interface AppDelegateHelper : NSObject<PycFileDelegate>
singleton_interface(AppDelegateHelper);

@property(nonatomic,strong)NSString *phoneNo;
@property(nonatomic,strong)NSString *messageID;
@property(nonatomic,assign)NSInteger openedNum;

-(BOOL)openURLOfPycFileByLaunchedApp:(NSString*)openURL;

-(BOOL)getVerificationCodeByPhone:(NSString *)phone userPhone:(BOOL)userPhone;

-(BOOL)getApplyFileInfoByApplyId:(NSInteger)applyId;

-(void)setAlertView:(NSString *)msg;

//申请手动激活
- (NSString *)applyFileByFidAndOrderId:(NSInteger )fileId orderId:(NSInteger )thOrderId qq:(NSString *)theQQ email:(NSString *)theEmail phone:(NSString *)thePhone field1:(NSString *)theField1 field2:(NSString *)theField2 seeLogName:(NSString *)theSeeLogName fileName:(NSString*)theFileName;
@end
