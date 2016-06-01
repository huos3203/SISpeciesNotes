//
//  MyViewController.m
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/6/1.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController

-(void)viewDidLoad{
    MyProtocol * protocol = [[MyProtocol alloc] init];
    protocol.delegate = self;
    
    MyDelegate * delegate = [[MyDelegate alloc] init];
    delegate.delegate = self;
    
    PycFile *pyc = [[PycFile alloc]init];
    pyc.delegate = self;    
}

-(void)name:(NSString *)name{
    //
}
@end
