//
//  DOUFMFileUtil.h
//  DoubanFMMusicLibrary
//
//  Created by Jianjun Wu on 2/20/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUMobileStatFileUtil : NSObject

+ (NSString *)createDirectoryInDocumentWithSubPath:(NSString *)subPath;
+ (NSString *)createDirectoryInLibraryCacheWithSubPath:(NSString *)subPath;
+ (BOOL)addSkipBackupAttributeToPath:(NSString *)filepath;

// Sort by modified time the file
+ (NSArray *)sortedPathsByTimeIncrease:(NSString *)dirPath;
/**
 * 清除老的文件
 * @Param keepNum 保留的文件数量; 0 标示无限制
 * @Param maxSize 保留的总大小，单位为byte; 0 标示无限制
 * Return : 返回删除的数量
 */
+ (NSInteger)clearOldFilesInDirctory:(NSString *)dirPath
                             keepNum:(NSUInteger)keepNum
                            keepSize:(NSUInteger)maxSize;
+ (void)deleteAllFilesInDirctory:(NSString *)dirPath;

@end
