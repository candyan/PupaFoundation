//
//  DOUMobileStatDefaultValues.m
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/9/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUMobileStatDefaultValues.h"

#ifdef DEBUG_SDK
NSInteger const kDOUMaxNumbersOfEventsPerFile = 10;
NSInteger const kDOUMaxNumbersOfFilesForNormalEvent = 5;
NSInteger const kDOUMaxNumbersOfFilesForImportantEvent = 2;
#else
NSInteger const kDOUMaxNumbersOfEventsPerFile = 500;
NSInteger const kDOUMaxNumbersOfFilesForNormalEvent = 10;
NSInteger const kDOUMaxNumbersOfFilesForImportantEvent = 10;
#endif

/*
 目录结构：
 + Library/DOUStatLib
  + log
    + normal
    + important
 */

NSString *const kDOUMobileStatBaseFolder = @"DOUStatLib";

@implementation DOUMobileStatDefaultValues

+ (NSString *)dirPathOfMobileStat
{
  static NSString *dirPathOfMobileStat = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    dirPathOfMobileStat = [[libPath stringByAppendingPathComponent:kDOUMobileStatBaseFolder] copy];
  });
  return dirPathOfMobileStat;
}

+ (NSString *)dirPathOfLogs
{
  static NSString *dirPathOfLogs = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dirPathOfLogs = [[[self dirPathOfMobileStat] stringByAppendingPathComponent:@"log"] copy];
  });
  return dirPathOfLogs;
}

+ (NSString *)filePathOfStatInfoFile
{
  static NSString *filePathOfStatInfoFile = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    filePathOfStatInfoFile = [[[self dirPathOfMobileStat] stringByAppendingPathComponent:@"info.plist"] copy];
  });
  return filePathOfStatInfoFile;
}

+ (NSString *)dirPathOfNormalLog
{
  static NSString *dirPathOfNormalLog = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dirPathOfNormalLog = [[[self dirPathOfLogs] stringByAppendingPathComponent:@"normal"] copy];
  });
  return dirPathOfNormalLog;
}

+ (NSString *)dirPathOfImportantLog
{
  static NSString *dirPathOfImportantLog = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dirPathOfImportantLog = [[[self dirPathOfLogs] stringByAppendingPathComponent:@"important"] copy];
  });
  return dirPathOfImportantLog;
}

@end
