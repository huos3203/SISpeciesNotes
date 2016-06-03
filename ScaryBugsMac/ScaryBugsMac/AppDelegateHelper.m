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
#import "SeriesDao.h"
#import "LookMedia.h"
#import "ToolString.h"
#import <Cocoa/Cocoa.h>

@implementation AppDelegateHelper
{
    PycFile *fileManager;
    int fileID;
    NSString *filePath;
    BOOL isReceiveFileExist;
    OutFile *outFile;
    PycFile *seePycFile;
    int returnValue;
    AdvertisingView *custormActivityView;
    NSInteger applyNum; //自动激活次数
}

-(BOOL)openURLOfPycFileByLaunchedApp:(NSString *)openURL
{
    fileManager = [[PycFile alloc]init];
    fileManager.delegate = self;
    filePath = openURL;
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
//    AdvertisingView *custormActivityView = [[NSNib new] initWithNibNamed:@"AdvertisingView" bundle:nil][0];

    custormActivityView = (AdvertisingView *)[[NSWindowController alloc] initWithWindowNibName:@"AdvertisingView"];
    
    [custormActivityView startLoading:fileID isOutLine:OutLine];
    
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
                //              applyNum=0;
                
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

#pragma mark - PycFile
#pragma mark 查看文件
- (void)PycFile:(PycFile *)fileObject didFinishSeePycFileForUser:(MAKEPYCRECEIVE *)receiveData
{
    seePycFile = fileObject;
    returnValue = receiveData->returnValue;
    
    if (custormActivityView.advertime<3) {
        ////判断，广告加载完成后，再延迟3秒钟
        [self performSelector:@selector(didFinishSeePycFileForUser) withObject:nil afterDelay:3.0f];
    }else{
        [self didFinishSeePycFileForUser];
    }
}

- (void)didFinishSeePycFileForUser
{
    if(returnValue == -1)
    {
        [custormActivityView removeFromSuperview];
        return;
    }
    if(returnValue & ERR_NEED_UPDATE)
    {
        applyNum =0;
        [custormActivityView removeFromSuperview];
        return;
    }
    
    NSArray *arr =@[@"jpg", @"png", @"pdf", @"mp4",@"3gp",@"mov", @"mp3", @"wav",@"flv",@"wmv"];
    NSRange rang;
    for (int i =0 ; i<[arr count]; i++) {
        rang = [[seePycFile.filePycNameFromServer lowercaseString] rangeOfString:[NSString stringWithFormat:@".%@",arr[i]]];
        if (rang.length>0) {
            break;
        }
    }
    if (rang.length == 0) {
        [[ReceiveFileDao sharedReceiveFileDao]updateReceiveFileApplyOpen:0 FileId:fileID];//seePycFile.fileID];
        [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileIsChangeTime:fileID isChangeTime:1];
        [self setAlertView:@"暂不支持此格式，请在PC端阅读。\n移动端支持的格式：\njpg/png/pdf/mp4/3gp/mov/mp3/wav/flv/wmv"];
        
        return;
    }
    
    
    //更新接收查看文件
    NSDate *startDay = [NSDate dateWithStringByDay:seePycFile.startDay];
    NSDate *endDay = [NSDate dateWithStringByDay:seePycFile.endDay];
    
    NSDate *receiveDay = [NSDate dateWithStringByDay:seePycFile.firstSeeTime];
    NSDate *makeTime = [NSDate dateWithStringByDay:seePycFile.makeTime];
    
    
    // MakeType:returnValue & ERR_FREE?1:0
    NSInteger makeType = returnValue & ERR_FREE?1:0;
    NSInteger forbid = 0;
    NSInteger isEye = 1;
    NSString *qq = seePycFile.QQ;
    //自由传播
    if (makeType == 1) {
        isEye = 1;
        forbid = seePycFile.iCanOpen;
    }else{
        //手动激活， 1，已激活，0:未激活
        forbid = 0;
        isEye = seePycFile.canseeCondition==1;
    }
    
    //能看且是手动激活
    if((returnValue & ERR_OK_OR_CANOPEN)&&(returnValue & ERR_OK_IS_FEE) && isReceiveFileExist)
    {
        qq = @"#cansee";
    }
    
    
    //第一open In 本地没有该文件时更新
    if (!isReceiveFileExist) {
        //存储到SQLite 接收文件
        NSString *sandbox = [SandboxFile GetHomeDirectoryPath];
        NSString *filePath = [seePycFile.filePycName stringByReplacingOccurrencesOfString:sandbox withString:@""];
        [[ReceiveFileDao sharedReceiveFileDao] saveReceiveFile:[OutFile initWithReceiveFileId:fileID//seePycFile.fileID
                                                                                     FileName:[seePycFile.filePycNameFromServer stringByDeletingPathExtension]
                                                                                      LogName:seePycFile.fileSeeLogname
                                                                                    FileOwner:seePycFile.fileOwner
                                                                                FileOwnerNick:seePycFile.nickname
                                                                                      FileUrl:filePath
                                                                                     FileType:seePycFile.fileExtentionWithOutDot
                                                                                  ReceiveTime:receiveDay
                                                                                    StartTime:startDay
                                                                                      EndTime:endDay
                                                                                    LimitTime:seePycFile.openTimeLong
                                                                                       Forbid:forbid
                                                                                     LimitNum:seePycFile.AllowOpenmaxNum
                                                                                      ReadNum:seePycFile.haveOpenedNum
                                                                                         Note:seePycFile.remark
                                                                                       Reborn:0
                                                                                       FileQQ:qq
                                                                                    FileEmail:seePycFile.email
                                                                                    FilePhone:seePycFile.phone
                                                                                  FileOpenDay:seePycFile.openDay
                                                                                FileDayRemain:seePycFile.dayRemain
                                                                                 FileOpenYear:seePycFile.openYear
                                                                               FileYearRemain:seePycFile.yearRemain
                                                                                 FileMakeType:makeType
                                                                                 FileMakeTime:makeTime
                                                                                      AppType:seePycFile.makeFrom
                                                                                        isEye:isEye]];
        [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileFirstOpenTime:seePycFile.firstSeeTime FileId:fileID];//seePycFile.fileID];
        
    } else {
        [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFile:[OutFile initWithReceiveFileId:fileID//seePycFile.fileID
                                                                                       FileName:[seePycFile.filePycNameFromServer stringByDeletingPathExtension]
                                                                                        LogName:seePycFile.fileSeeLogname
                                                                                      FileOwner:seePycFile.fileOwner
                                                                                  FileOwnerNick:seePycFile.nickname
                                                                                        FileUrl:seePycFile.filePycName
                                                                                       FileType:seePycFile.fileExtentionWithOutDot
                                                                                    ReceiveTime:receiveDay
                                                                                      StartTime:startDay
                                                                                        EndTime:endDay
                                                                                      LimitTime:seePycFile.openTimeLong
                                                                                         Forbid:forbid
                                                                                       LimitNum:seePycFile.AllowOpenmaxNum
                                                                                        ReadNum:seePycFile.haveOpenedNum
                                                                                           Note:seePycFile.remark
                                                                                         Reborn:0
                                                                                         FileQQ:qq
                                                                                      FileEmail:seePycFile.email
                                                                                      FilePhone:seePycFile.phone
                                                                                    FileOpenDay:seePycFile.openDay
                                                                                  FileDayRemain:seePycFile.dayRemain
                                                                                   FileOpenYear:seePycFile.openYear
                                                                                 FileYearRemain:seePycFile.yearRemain
                                                                                   FileMakeType:makeType
                                                                                   FileMakeTime:makeTime
                                                                                        AppType:seePycFile.makeFrom
                                                                                          isEye:isEye]];
        [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileFirstOpenTime:seePycFile.firstSeeTime FileId:fileID];//seePycFile.fileID];
        
    }
    
    /*!
     *  @author shuguang, 15-06-10 15:06:27
     *
     *  @brief 将以前的离线文件信息，转移至本地数据库中
     *
     */
    if((returnValue & ERR_OK_OR_CANOPEN) && (returnValue & ERR_OK_IS_FEE))
    {
        [[ReceiveFileDao sharedReceiveFileDao] updateByFileIdReceiveFile:[OutFile initWithReceiveFileId:fileID//seePycFile.fileID
                                                                                                ApplyId:seePycFile.applyId
                                                                                                actived:seePycFile.activeNum
                                                                                                 field1:seePycFile.field1
                                                                                                 field2:seePycFile.field2
                                                                                             field1name:seePycFile.fild1name
                                                                                             field2name:seePycFile.fild2name
                                                                                                 hardno:seePycFile.hardno
                                                                                              EncodeKey:seePycFile.fileSecretkeyR1
                                                                                           SelfFieldNum:seePycFile.selffieldnum
                                                                                          DefineChecked:seePycFile.definechecked
                                                                                            WaterMarkQQ:seePycFile.QQ
                                                                                         WaterMarkPhone:seePycFile.phone
                                                                                         WaterMarkEmail:seePycFile.email]];
    }
    
    //将系列ID和文件关联
    [[ReceiveFileDao sharedReceiveFileDao] updateReceiveSeriesID:seePycFile.seriesID fileId:fileID];//seePycFile.fileID];
    
    //        if (seePycFile.seriesID != 0) {
    //TODO:插入系列表信息
    SeriesModel *series = [[SeriesModel alloc] init];
    series.seriesID = seePycFile.seriesID;
    series.seriesFileNum = seePycFile.seriesFileNums;
    series.seriesName = [seePycFile.seriesName stringByReplacingOccurrencesOfString:@"\0"withString:@""];//seePycFile.seriesName;
    series.seriesAuthor = seePycFile.nickname;
    series.seriesClass = makeType;
    [[SeriesDao sharedSeriesDao] insertToSeries:series];
    //        }
    
    
    
    
    //查看广告后，保存Uid
    if (custormActivityView.uid != -1) {
        [[ReceiveFileDao sharedReceiveFileDao] updateReceiveUid:custormActivityView.uid fileId:fileID];//seePycFile.fileID];
    }
    
    //can open
    if(returnValue & ERR_OK_OR_CANOPEN)
    {
        [custormActivityView removeFromSuperview];
        applyNum =0;
        if (returnValue & ERR_OK_IS_FEE)
        {
            //重生0：未使用 1：已使用
            [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileToRebornedByFileId:fileID Status:0];//seePycFile.fileID Status:0];
            [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileApplyOpen:1 FileId:fileID];//seePycFile.fileID];
            
            LookMedia *look = [[LookMedia alloc] init];
            look.urlImagePath = seePycFile.fileName;
            look.limitTime = seePycFile.openTimeLong;
            look.bOpenInCome = 1;
            look.receviveFileId = [NSString stringWithFormat:@"%ld",(long)fileID];//seePycFile.fileID];
            //水印
            look.waterMark = [self waterMark:seePycFile];
            look.openinfoid = seePycFile.openinfoid;
            look.fileSecretkeyR1 = seePycFile.fileSecretkeyR1;
            look.EncryptedLen = seePycFile.encryptedLen;
            look.imageData = seePycFile.imageData;
            
//            [look lookMedia:_navRootVc];
        }
        else if(returnValue & ERR_FEE_SALER)
        {
            //有独享条件可以申请，目前用不到 ，自由传播转为手动激活的情况
            
        }
        else
        {
            //重生0：未使用 1：已使用
            [[ReceiveFileDao sharedReceiveFileDao] updateReceiveFileToRebornedByFileId:fileID Status:0];//seePycFile.fileID
            
            LookMedia *look = [[LookMedia alloc] init];
            look.urlImagePath = seePycFile.fileName;
            look.limitTime = seePycFile.openTimeLong;
            look.bOpenInCome = 1;
            look.receviveFileId = [NSString stringWithFormat:@"%ld",(long)fileID];//seePycFile.fileID];
            //水印
            //                look.waterMark = [self waterMark:seePycFile];
            //                look.openinfoid = seePycFile.openinfoid;
            look.fileSecretkeyR1 = seePycFile.fileSecretkeyR1;
            look.EncryptedLen = seePycFile.encryptedLen;
            look.imageData = seePycFile.imageData;
            
//            [look lookMedia:_navRootVc];
        }
    }
}

-(void)setAlertView:(NSString *)msg
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"我知道了"];
    //        [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:msg];
    //        [alert setInformativeText:@"Deleted records cannot be restored."];
    [alert setAlertStyle:NSWarningAlertStyle];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK clicked, delete the record
        
    }
}

#pragma mark  组装水印信息
-(NSString *)waterMark:(PycFile *)fileObject
{
    NSString *waterMark = nil;
    NSMutableArray *replace = [[NSMutableArray alloc] initWithArray:@[@"Q Q:",@"邮箱:",@"\n",@"手机:"]];
    if (fileObject.definechecked || fileObject.selffieldnum) {
        if (fileObject.definechecked&1
            && ![ToolString isBlankString:fileObject.QQ]) {
            waterMark = [NSString stringWithFormat:@"Q Q:%@",fileObject.QQ];
        }
        if (fileObject.definechecked&2
            && ![ToolString isBlankString:fileObject.phone]) {
            
            if (![ToolString isBlankString:waterMark]) {
                waterMark = [NSString stringWithFormat:@"%@\n手机:%@",waterMark,fileObject.phone];
            }else{
                waterMark = [NSString stringWithFormat:@"手机:%@",fileObject.phone];
            }
            
        }
        if (fileObject.definechecked&4
            && ![ToolString isBlankString:fileObject.email]) {
            
            if (![ToolString isBlankString:waterMark]) {
                waterMark = [NSString stringWithFormat:@"%@\n邮箱:%@",waterMark,fileObject.email];
            }else{
                waterMark = [NSString stringWithFormat:@"邮箱:%@",fileObject.email];
            }
        }
        
        
        if (fileObject.selffieldnum==1
            && fileObject.field1needprotect!=1
            && ![ToolString isBlankString:fileObject.fild1name]
            && ![ToolString isBlankString:fileObject.field1]) {
            
            [replace addObject:fileObject.fild1name];
            if (![ToolString isBlankString:waterMark]) {
                waterMark = [NSString stringWithFormat:@"%@\n%@:%@",waterMark,fileObject.fild1name,fileObject.field1];
            }else{
                waterMark = [NSString stringWithFormat:@"%@:%@",fileObject.fild1name,fileObject.field1];
            }
        }
        
        if (fileObject.selffieldnum==2) {
            
            if (fileObject.field1needprotect!=1
                && ![ToolString isBlankString:fileObject.fild1name]
                && ![ToolString isBlankString:fileObject.field1]) {
                
                [replace addObject:fileObject.fild1name];
                if (![ToolString isBlankString:waterMark]) {
                    waterMark = [NSString stringWithFormat:@"%@\n%@:%@",waterMark,fileObject.fild1name,fileObject.field1];
                }else{
                    waterMark = [NSString stringWithFormat:@"%@:%@",fileObject.fild1name,fileObject.field1];
                }
            }
            
            if (fileObject.field2needprotect!=1
                && ![ToolString isBlankString:fileObject.fild2name]
                && ![ToolString isBlankString:fileObject.field2]) {
                
                [replace addObject:fileObject.fild2name];
                
                if (![ToolString isBlankString:waterMark]) {
                    waterMark = [NSString stringWithFormat:@"%@\n%@:%@",waterMark,fileObject.fild2name,fileObject.field2];
                }else{
                    waterMark = [NSString stringWithFormat:@"%@:%@",fileObject.fild2name,fileObject.field2];
                }
            }
        }
    } else {
        // 默认选项
        NSString *qq = fileObject.QQ;
        NSString *email = fileObject.email;
        NSString *phone = fileObject.phone;
        
        if (![ToolString isBlankString:qq]) {
            waterMark = [NSString stringWithFormat:@"Q Q:%@", qq];
        }
        if (![ToolString isBlankString:phone]) {
            if(![ToolString isBlankString:waterMark])
            {
                waterMark = [NSString stringWithFormat:@"%@\n手机:%@", waterMark,phone];
            }else{
                waterMark = [NSString stringWithFormat:@"手机:%@",phone];
            }
        }
        if (![ToolString isBlankString:email]) {
            if(![ToolString isBlankString:waterMark])
            {
                waterMark = [NSString stringWithFormat:@"%@\n邮箱:%@", waterMark,email];
            }else{
                waterMark = [NSString stringWithFormat:@"邮箱:%@",phone];
            }
        }
    }
    if([fileObject.fileExtentionWithOutDot fileIsTypeOfVideo])
    {
        waterMark = [waterMark stringReplaceDelWater:replace];
    }
    
    return waterMark;
    
}

@end
