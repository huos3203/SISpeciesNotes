//
//  MyInstallerPane.m
//  mpv-install
//
//  Created by pengyucheng on 16/6/24.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "MyInstallerPane.h"

@implementation MyInstallerPane

- (NSString *)title
{
	return [[NSBundle bundleForClass:[self class]] localizedStringForKey:@"PaneTitle" value:nil table:nil];
}

@end
