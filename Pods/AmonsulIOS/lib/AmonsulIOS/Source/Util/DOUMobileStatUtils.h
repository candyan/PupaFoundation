//
//  ToolUtils.h
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DOUMobileStatUtils : NSObject

+ (void) deleteLocalFile:(NSString*) fileName;
+ (void) deleteLocalFileAsync:(NSString*) fileName;
+ (void) deleteLocalFileAsync:(NSString*) fileName successful:(void (^)(BOOL ret)) block;

+ (void) deleteItem:(NSString *) fileName;
+ (void) appendItem:(NSString*) fileName;

+ (NSString *) jsonStringWithArray:(NSArray*) array;
+ (NSString *) jsonStringWithDictionary:(NSDictionary *) dictionary;
+ (NSString *) jsonStringWithString:(NSString *) string;
+ (NSString *) jsonStringWithObject:(id) object;

+ (NSString *) urlEscapeString:(NSString *) unencodedString;
+ (NSString *) addQueryStringToUrlString:(NSString *) urlString withDictionary:(NSDictionary *) dictionary;

+ (BOOL) addSkipBackupAttributeToPath:(NSString *) filepath;

+ (NSString *)localTimeStringForNow;

#pragma mark - backgroud task
+ (void)startBackgroundTask;
+ (void)endBackgroundTask;
+ (void)endBackgroundTaskByID:(UIBackgroundTaskIdentifier)backgroundTaskID;

@end
