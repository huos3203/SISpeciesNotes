//
//  MyProtocol.h
//  ScaryBugsMac
//
//  Created by huoshuguang on 16/5/31.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PycSocket.h"
@class PycFile;
@class PycSocket;
@protocol dddProtocol <NSObject>
@optional
-(void)name:(NSString*)name;

@end


@interface MyProtocol : NSObject<PycSocketDelegate>
singleton_interface(MyProtocol)

@property(nonatomic,assign)id<dddProtocol> delegate;
@end
