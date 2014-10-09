//
//  DOUMobileStatEventStorage.h
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/9/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DOUStatEvent;

@interface DOUMobileStatEventStorage : NSObject

@property (nonatomic, assign) NSInteger maxEventsPerFile;
@property (nonatomic, assign) NSInteger maxNormalEventFileNumber;
@property (nonatomic, assign) NSInteger maxImportantEventFileNumber;

+ (DOUMobileStatEventStorage *)sharedInstance;

- (void)writelEventToDisk:(DOUStatEvent *)event;
- (void)asyncWritelEventToDisk:(DOUStatEvent *)event;

- (void)deleteEventLogFile:(NSString *)filePath;
- (void)addSendingPath:(NSString *)path;
- (void)removeSendingPath:(NSString *)path;
- (BOOL)isSendingEventLogFile:(NSString *)path;

- (NSInteger)numberOfNormalLogFiles;
- (NSArray *)sortedPathsOfNormalLogFilesByTimeIncrease;
- (NSArray *)sortedPathsOfImportantLogFilesByTimeIncrease;

- (NSInteger)clearOldNormalLogFiles;
- (NSInteger)clearOldImportLogFiles;

- (void)resetCachedFileIndexes;

@end
