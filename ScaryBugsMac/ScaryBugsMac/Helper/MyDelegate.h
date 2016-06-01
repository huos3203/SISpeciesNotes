//
//  MyDelegate.h
//  ScaryBugsMac
//
//  Created by  on 16/6/1.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol myyProtocol <NSObject>

-(void)name:(NSString *)name;

@end

@interface MyDelegate : NSObject

@property(nonatomic,assign) id<myyProtocol> delegate;
@end
