//
//  main.m
//  mpv-examples
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    return NSApplicationMain(argc, argv);
}



//#ifndef MPV_MACOSX_APPLICATION
//#define MPV_MACOSX_APPLICATION
//
//// Menu Keys identifing menu items
//typedef enum {
//    MPM_H_SIZE,
//    MPM_N_SIZE,
//    MPM_D_SIZE,
//    MPM_MINIMIZE,
//    MPM_ZOOM,
//} MPMenuKey;
//
//// multithreaded wrapper for mpv_main
//int cocoa_main(int argc, char *argv[]);
//void cocoa_register_menu_item_action(MPMenuKey key, void* action);
//
//#endif /* MPV_MACOSX_APPLICATION */