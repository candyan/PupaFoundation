//
//  DOUMobileStatDefaultValues.h
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/9/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kDOUMaxNumbersOfEventsPerFile;
extern NSInteger const kDOUMaxNumbersOfFilesForNormalEvent;
extern NSInteger const kDOUMaxNumbersOfFilesForImportantEvent;

@interface DOUMobileStatDefaultValues : NSObject

/*
 * 统计类库的更目录
 */
+ (NSString *)dirPathOfMobileStat;
/*
 * 保存了统计类库当前状态的文件地址
 */
+ (NSString *)filePathOfStatInfoFile;

/*
 * 保存事件日志的的目录
 */
+ (NSString *)dirPathOfLogs;
/*
 * 普通日志的目录路径
 */
+ (NSString *)dirPathOfNormalLog;
/*
 * 重要日志的目录路径
 */
+ (NSString *)dirPathOfImportantLog;

@end
