//
//  DOUMobileStatEventStorage.m
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/9/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//
#include <sys/xattr.h>
#include <sys/stat.h>
#import "DOUMobileStatEventStorage.h"
#import "DOUMobileStatDefaultValues.h"
#import "DOUMobileStatFileUtil.h"
#import "DOUStatEvent.h"
#import "DOUStatConstant.h"

static NSString *const kDOUStatEventsLogFileSuffix = @"plist";

static DOUMobileStatEventStorage *__instance;

@interface DOUMobileStatEventStorage ()
@property (nonatomic, strong) NSOperationQueue *fileQueue;
@property (nonatomic, strong) NSMutableArray *sortedPathsForNormal;
@property (nonatomic, strong) NSMutableArray *sortedPathsForImportant;
@property (nonatomic, strong) NSMutableSet *sendingPaths;
// 下面两个property是用于cache文件中的event的数组，在第一次加载可append文件时加载数据
@property (nonatomic, strong) NSMutableArray *eventsInLatestNormalLogFile;
@property (nonatomic, strong) NSMutableArray *eventsInLatestImportantLogFile;
@end

@implementation DOUMobileStatEventStorage

- (void)writelEventToDisk:(DOUStatEvent *)event
{
  if (event == nil) {
    DERRORLOG(@"event should not be nil");
    return;
  }
  [self writelNormalEventToDisk:event];
}

- (void)asyncWritelEventToDisk:(DOUStatEvent *)event
{
  if (event == nil) {
    DERRORLOG(@"event should not be nil");
    return;
  }
  [self.fileQueue addOperationWithBlock:^{
    [self writelEventToDisk:event];
  }];
}

- (void)writeArray:(NSArray *)arr toFile:(NSString *)fileToAppend
{
  if (arr == nil) {
    return;
  }
  @try {
    BOOL succeed = [arr writeToFile:fileToAppend atomically:YES];
    if (succeed) {
      DTRACELOG(@"Succeeded to write event '%@' to file %@", arr.lastObject, fileToAppend);
    } else {
      DERRORLOG(@"Failed to write event '%@', to file %@", arr.lastObject, fileToAppend);
    }
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (void)writelNormalEventToDisk:(DOUStatEvent *)event
{
  NSString *fileToAppend = [self latestFileCanBeUsedToAppendForNormal];
  if (fileToAppend) {
    [self.eventsInLatestNormalLogFile addObject:[event toMutableDictionary]];
    DTRACELOG(@"append event to file %@", fileToAppend);
  } else {
    fileToAppend = [self filePathOfEventLogFileForNormalEvent];
    self.eventsInLatestNormalLogFile = [NSMutableArray arrayWithObject:[event toMutableDictionary]];
    BOOL created = [[NSFileManager defaultManager] createFileAtPath:fileToAppend
                                                           contents:nil
                                                         attributes:nil];
    DINFOLOG(@"create new event file %@, succeed: %d", fileToAppend, created);
    if (created) {
      [self.sortedPathsForNormal addObject:fileToAppend];
    } else {
      DERRORLOG(@"Failed to create new event file %@, succeed: %d", fileToAppend, created);
    }
  }
  [self writeArray:self.eventsInLatestNormalLogFile toFile:fileToAppend];
}

- (void)deleteEventLogFile:(NSString *)filePath
{
  @try {
    [self.sendingPaths removeObject:filePath];
    [self.sortedPathsForNormal removeObject:filePath];
    [self.sortedPathsForImportant removeObject:filePath];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (void)addSendingPath:(NSString *)path
{
  if (path == nil || path.length < 1) {
    return;
  }
  
  [self.sendingPaths addObject:path];
  [self updateSortedPathsIfNotExisted];
  if (self.eventsInLatestNormalLogFile && [path isEqualToString:self.sortedPathsForNormal.lastObject]) {
    self.eventsInLatestNormalLogFile = nil;
  } else if (self.eventsInLatestImportantLogFile && [path isEqualToString:self.sortedPathsForImportant.lastObject]) {
    self.eventsInLatestImportantLogFile = nil;
  }
}

- (void)removeSendingPath:(NSString *)path
{
  if (path == nil || path.length < 1) {
    return;
  }
  [self.sendingPaths removeObject:path];
}

- (BOOL)isSendingEventLogFile:(NSString *)path
{
  return [self.sendingPaths containsObject:path];
}

- (NSInteger)numberOfNormalLogFiles
{
  NSString *normalLogDir = [DOUMobileStatDefaultValues dirPathOfNormalLog];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:normalLogDir error:&error];
  if (filesArray) {
    return [filesArray count];
  } else {
    return 0;
  }
}

- (NSArray *)sortedPathsOfNormalLogFilesByTimeIncrease
{
  if (self.sortedPathsForNormal == nil) {
    NSString *normalLogDir = [DOUMobileStatDefaultValues dirPathOfNormalLog];
    NSArray *arr = [DOUMobileStatFileUtil sortedPathsByTimeIncrease:normalLogDir];
    self.sortedPathsForNormal = [NSMutableArray arrayWithArray:arr ? arr:@[]];
    [self filterFilesByEventLogFileSuffix:self.sortedPathsForNormal];
  }
  return self.sortedPathsForNormal;
}

- (NSArray *)sortedPathsOfImportantLogFilesByTimeIncrease
{
  if (self.sortedPathsForImportant == nil) {
    NSString *importantLogDir = [DOUMobileStatDefaultValues dirPathOfImportantLog];
    NSArray *arr = [DOUMobileStatFileUtil sortedPathsByTimeIncrease:importantLogDir];
    self.sortedPathsForImportant = [NSMutableArray arrayWithArray:arr ? arr:@[]];
    [self filterFilesByEventLogFileSuffix:self.sortedPathsForImportant];
  }
  return self.sortedPathsForImportant;
}

- (void)filterFilesByEventLogFileSuffix:(NSMutableArray *)filePathArr
{
  NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
  NSUInteger index = 0;
  for (NSString *filePath in filePathArr) {
    if ([filePath hasSuffix:kDOUStatEventsLogFileSuffix] == NO) {
      [set addIndex:index];
    }
    ++index;
  }
  [filePathArr removeObjectsAtIndexes:set];
}

- (NSInteger)clearOldNormalLogFiles
{
  @try {
    NSString *normalLogDir = [DOUMobileStatDefaultValues dirPathOfNormalLog];
    NSInteger clearedNum = [DOUMobileStatFileUtil clearOldFilesInDirctory:normalLogDir
                                                                  keepNum:self.maxNormalEventFileNumber
                                                                 keepSize:0];
    self.sortedPathsForNormal = nil;
    self.eventsInLatestNormalLogFile = nil;
    return clearedNum;
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (NSInteger)clearOldImportLogFiles
{
  @try {
    NSString *importantLogDir = [DOUMobileStatDefaultValues dirPathOfImportantLog];
    NSInteger clearedNum = [DOUMobileStatFileUtil clearOldFilesInDirctory:importantLogDir
                                                                  keepNum:self.maxImportantEventFileNumber
                                                                 keepSize:0];
    self.sortedPathsForImportant = nil;
    self.eventsInLatestImportantLogFile = nil;
    return clearedNum;
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (void)resetCachedFileIndexes
{
  self.sortedPathsForNormal = nil;
  self.sortedPathsForImportant = nil;
  [self.sendingPaths removeAllObjects];
  self.eventsInLatestNormalLogFile = nil;
  self.eventsInLatestImportantLogFile = nil;
}

#pragma mark -  util method
- (NSString *)latestFileCanBeUsedToAppendForNormal
{
  NSArray *currentFiles = [self sortedPathsOfNormalLogFilesByTimeIncrease];
  NSString *lastestFile = [currentFiles lastObject];
  BOOL isSending = [self.sendingPaths containsObject:lastestFile];
  if (isSending) {
    return nil;
  }
  @try {
    if (self.eventsInLatestNormalLogFile
        && [self.eventsInLatestNormalLogFile count] < self.maxEventsPerFile) {
      return lastestFile;
    }
    NSArray *arr = [NSArray arrayWithContentsOfFile:lastestFile];
    if (arr == nil || [arr count] < self.maxEventsPerFile) {
      self.eventsInLatestNormalLogFile = [NSMutableArray arrayWithArray:arr];
      return lastestFile;
    } else {
      return nil;
    }
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (NSString *)latestFileCanBeUsedToAppendForImportant
{
  NSArray *currentFiles = [self sortedPathsOfImportantLogFilesByTimeIncrease];
  NSString *lastestFile = [currentFiles lastObject];
  BOOL isSending = [self.sendingPaths containsObject:lastestFile];
  if (isSending) {
    return nil;
  }
  @try {
    if (self.eventsInLatestImportantLogFile && [self.eventsInLatestImportantLogFile count] < self.maxEventsPerFile) {
      return lastestFile;
    }
    NSArray *arr = [NSArray arrayWithContentsOfFile:lastestFile];
    if (arr == nil || [arr count] < self.maxEventsPerFile) {
      self.eventsInLatestImportantLogFile = [NSMutableArray arrayWithArray:arr];
      return lastestFile;
    } else {
      return nil;
    }
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

- (NSString *)filePathOfEventLogFileForNormalEvent
{
  long long millonSecondsSince1970 = [[NSDate date] timeIntervalSince1970] * 1000;
  NSString *filename = [NSString stringWithFormat:@"normal_%lld", millonSecondsSince1970];
  filename = [filename stringByAppendingPathExtension:kDOUStatEventsLogFileSuffix];
  return [[DOUMobileStatDefaultValues dirPathOfNormalLog] stringByAppendingPathComponent:filename];
}

- (NSString *)filePathOfEventLogFileForImportEvent
{
  long long millonSecondsSince1970 = [[NSDate date] timeIntervalSince1970] * 1000;
  NSString *filename = [NSString stringWithFormat:@"important_%lld", millonSecondsSince1970];
  filename = [filename stringByAppendingPathExtension:kDOUStatEventsLogFileSuffix];
  return [[DOUMobileStatDefaultValues dirPathOfImportantLog] stringByAppendingPathComponent:filename];
}

- (void)updateSortedPathsIfNotExisted
{
  [self sortedPathsOfNormalLogFilesByTimeIncrease];
  [self sortedPathsOfImportantLogFilesByTimeIncrease];
}

#pragma mark -  singleton methods
- (id)init
{
  self = [super init];
  if (self) {
    self.fileQueue = [[NSOperationQueue alloc] init];
    [self.fileQueue setMaxConcurrentOperationCount:1];
    self.sendingPaths = [NSMutableSet setWithCapacity:8];
    self.maxEventsPerFile = kDOUMaxNumbersOfEventsPerFile;
    self.maxNormalEventFileNumber = kDOUMaxNumbersOfFilesForNormalEvent;
    self.maxImportantEventFileNumber = kDOUMaxNumbersOfFilesForImportantEvent;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:[DOUMobileStatDefaultValues dirPathOfImportantLog]
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    [fm createDirectoryAtPath:[DOUMobileStatDefaultValues dirPathOfNormalLog]
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
  }
  return self;
}

+ (DOUMobileStatEventStorage *)sharedInstance
{
  if (__instance == nil) {
    __instance = [[super allocWithZone:NULL] init];
  }
  return __instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
