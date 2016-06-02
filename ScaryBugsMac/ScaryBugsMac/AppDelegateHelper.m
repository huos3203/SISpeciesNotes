//
//  AppDelegateHelper.m
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/6/2.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import "AppDelegateHelper.h"
#import "ReceiveFileDao.h"
#import "userDao.h"
#import "AdvertisingView.h"
@import AppKit;
@implementation AppDelegateHelper
{
    PycFile *fileManager;
    int fileID;
    NSString *filePath;
    OutFile *outFile;
}

-(BOOL)openURLOfPycFileByLaunchedApp:(NSURL *)openURL
{
    fileManager = [[PycFile alloc]init];
    fileManager.delegate = self;
    
    fileID = [fileManager getAttributePycFileId:filePath];
    if (fileID==0) {
        NSLog(@"读取文件失败。可能错误原因：文件下载不完整，请重新下载！");
        return YES;
    }

    // 判断已接受数据库是否存在
    NSString *fileName = @"";
    NSInteger openedNum = 0;
    BOOL OutLine = NO;
    NSString *logname = [[userDao shareduserDao] getLogName];
    BOOL isReceiveFileExist = [[ReceiveFileDao sharedReceiveFileDao] findFileById:fileID
                                                                       forLogName:logname];
    
    if (isReceiveFileExist) {
        //在接收列表存在
        outFile = [[ReceiveFileDao sharedReceiveFileDao] fetchReceiveFileCellByFileId:fileID LogName:logname];
        fileName = [NSString stringWithFormat:@"%@.pbb",outFile.filename];
        openedNum = outFile.readnum;
        
        if (outFile.fileMakeType == 0) {
            OutLine = YES;
        }
    }
    
    //
    AdvertisingView *custormActivityView = [[NSNib new] initWithNibNamed:@"AdvertisingView" bundle:nil][0];
//    [custormActivityView startLoading:fileID isOutLine:OutLine];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOffLine = FALSE;
        fileManager.receiveFile = outFile;
        NSString *result =[fileManager seePycFile2:filePath
                                        forUser:logname
                                        pbbFile:fileName
                                        phoneNo:@""
                                      messageID:@""
                                      isOffLine:&isOffLine
                                  FileOpenedNum:openedNum];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BOOL outLine = NO;
            if (isReceiveFileExist
                && isOffLine
                && [[ReceiveFileDao sharedReceiveFileDao] fetchUid:fileID]) {
                //离线且广告已缓存
                outLine = YES;
            }
            if (![result isEqualToString:@"0"]) {
                //              _applyNum=0;
                
                if (custormActivityView.advertime<3) {
                    ////判断，广告加载完成后，再延迟3秒钟
                    [self performSelector:@selector(didFinishSeePycFileForUser) withObject:nil afterDelay:3.0f];
                }else{
                    [self didFinishSeePycFileForUser];
                }
            }
        });
    });


    return YES;
    
}
@end
