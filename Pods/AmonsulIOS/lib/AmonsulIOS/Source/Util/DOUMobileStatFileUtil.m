//
//  DOUFMFileUtil.m
//  DoubanFMMusicLibrary
//
//  Created by Jianjun Wu on 2/20/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//
#import <UIKit/UIKit.h>
#include <sys/xattr.h>
#include <sys/stat.h>
#import "DOUMobileStatFileUtil.h"
#import "DOUStatConstant.h"

/**
 * 按照文件的访问时间顺序，最新的在最前面
 */
static NSInteger contentsOfDirSortByDecrease(NSString *left, NSString *right, void *ptr) {
  
  NSFileManager* fm = [NSFileManager defaultManager];
  NSDate * date_l = [[fm attributesOfItemAtPath:left error:nil] objectForKey: NSFileCreationDate];
  NSDate * date_r = [[fm attributesOfItemAtPath:right error:nil] objectForKey: NSFileCreationDate];
  return [date_r compare:date_l];
}

static NSInteger contentsOfDirSortByIncrease(NSString *left, NSString *right, void *ptr) {
  
  
  NSFileManager* fm = [NSFileManager defaultManager];
  NSDate * date_l = [[fm attributesOfItemAtPath:left error:nil] objectForKey: NSFileCreationDate];
  NSDate * date_r = [[fm attributesOfItemAtPath:right error:nil] objectForKey: NSFileCreationDate];
  return [date_l compare:date_r];
}

@implementation DOUMobileStatFileUtil

+ (NSString *)createDirectoryInDocumentWithSubPath:(NSString *)subPath {
  
  NSFileManager * fileManager = [NSFileManager defaultManager];
  NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString * fullPath = [docPath stringByAppendingPathComponent:subPath];
  BOOL succ = YES;
  if (NO == [fileManager fileExistsAtPath:fullPath]) {
    NSError * error = nil;
    succ = [fileManager createDirectoryAtPath:fullPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error];
    if (NO == succ) {
      DERRORLOG(@"Failed to create directory with error: %@", error);
    }
  }
  return succ ? fullPath : nil;
}

+ (NSString *)createDirectoryInLibraryCacheWithSubPath:(NSString *)subPath {
  
  NSFileManager * fileManager = [NSFileManager defaultManager];
  
  NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachePath = [cachePaths objectAtIndex:0];
  NSString * fullPath = [cachePath stringByAppendingPathComponent:subPath];
  BOOL succ = YES;
  if (NO == [fileManager fileExistsAtPath:fullPath]) {
    NSError * error = nil;
    succ = [fileManager createDirectoryAtPath:fullPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error];
    if (NO == succ) {
      DERRORLOG(@"Failed to create directory with error: %@", error);
    }
  }
  return succ ? fullPath : nil;
}

+ (BOOL)addSkipBackupAttributeToPath:(NSString *)filepath {
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO) {
    DTRACELOG(@"File path not exist in addSkipBackupAttributeToPath:");
    return NO;
  }
  
  float version = [[[UIDevice currentDevice] systemVersion] floatValue];
  const char * attrName = NULL;
  if (version < 5.f) {
    return YES;
  }
  if (version >= 5.1) {
    attrName = [NSURLIsExcludedFromBackupKey cStringUsingEncoding:NSASCIIStringEncoding];
  } else {
    attrName = "com.apple.MobileBackup";
  }
  u_int8_t attrValue = 1;
  const char* filePath = [filepath UTF8String];
  int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
  return result == 0;
}

+ (NSArray *)sortedPathsByTimeIncrease:(NSString *)dirPath {
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileName = nil;
  NSError *error;
  
  NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
  if (filesArray.count < 1) {
    return @[];
  }
  NSMutableArray * fileFullPathArrary = [NSMutableArray arrayWithCapacity:filesArray.count];
  for (fileName in filesArray) {
    [fileFullPathArrary addObject:[dirPath stringByAppendingPathComponent:fileName]];
  }
  NSArray *sortedFiles = [fileFullPathArrary sortedArrayUsingFunction:contentsOfDirSortByIncrease context:NULL];
  return sortedFiles;
}

+ (NSInteger)clearOldFilesInDirctory:(NSString *)dirPath
                             keepNum:(NSUInteger)num
                            keepSize:(NSUInteger)maxSize{
  
  DTRACELOG(@"clear old files for path: %@", dirPath);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileName = nil;
  NSError *error;
  
  NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
  if (filesArray.count < 1) {
    return 0;
  }
  NSMutableArray * fileFullPathArrary = [NSMutableArray arrayWithCapacity:filesArray.count];
  for (fileName in filesArray) {
    [fileFullPathArrary addObject:[dirPath stringByAppendingPathComponent:fileName]];
  }
  NSArray *sortedFiles = [fileFullPathArrary sortedArrayUsingFunction:contentsOfDirSortByDecrease context:NULL];
  
	int deletedCount=0;
	long deletedBytes=0;
  
  int remainingFileCount=0;
	long remainingBytes=0;
  
  NSString *fileFullPath = nil;
  struct stat fInfo;
  for (fileFullPath in sortedFiles) {    
    unsigned long long fileSize = 0L;
    if(-1 == stat([fileFullPath UTF8String], &fInfo)) {
      NSDictionary *fsAttributes = [fileManager attributesOfItemAtPath:fileFullPath error:&error];
      fileSize = [fsAttributes fileSize];
    } else {
      fileSize = fInfo.st_size;
    }
    if ((num > 0 && remainingFileCount >= num)
        || (maxSize > 0 && remainingBytes >= maxSize)) {
      NSError* err=nil;
			[fileManager removeItemAtPath:fileFullPath error:&err];
			if (err == nil) {
				deletedCount++;
				deletedBytes += fileSize;
			}
    } else {
      remainingFileCount++;
      remainingBytes += fileSize;
    }
  }
  DTRACELOG(@"clearOldFilesInDirctory delete files:%d delete bytes:%ld", deletedCount, deletedBytes);
  return deletedCount;
}

+ (void)deleteAllFilesInDirctory:(NSString *)dirPath {
  
  NSError *error = nil;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
  if (error) {
    DERRORLOG(@"delete all files in dir path:%@ error: %@", dirPath, error);
    return;
  }
  NSString *fileName = nil;
  for (fileName in filesArray) {
		NSString *fileFullPath = [dirPath stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:fileFullPath error:nil];
  }
  DTRACELOG(@"delete all files in dir path:%@", dirPath);
}

@end
