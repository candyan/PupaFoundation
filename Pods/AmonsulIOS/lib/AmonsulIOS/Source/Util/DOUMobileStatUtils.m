//
//  ToolUtils.m
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include <sys/xattr.h>
#import "DOUStatConstant.h"
#import "DOUMobileStatUtils.h"
#import "DOUStatEvent.h"
#import "DOUStatConfig.h"

static UIBackgroundTaskIdentifier globalBGTaskID;

@implementation DOUMobileStatUtils

+ (void)initialize
{
  globalBGTaskID = UIBackgroundTaskInvalid;
}

//
// 删除文件
// 删除制定文件名 (未处理异常） 采用异步方式(liuyan建议)
//

+ (void) deleteLocalFile:(NSString*) fileName {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  DTRACELOG(@"delete file %@",[fileName lastPathComponent]);
  [fileManager removeItemAtPath:fileName error:nil];
}

+ (void) deleteLocalFileAsync:(NSString*) fileName {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    DTRACELOG(@"delete file %@",[fileName lastPathComponent]);
    [fileManager removeItemAtPath:fileName error:nil];
  });
}

+ (void) deleteLocalFileAsync:(NSString*) fileName successful:(void (^)(BOOL ret)) block {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    DTRACELOG(@"delete file %@",[fileName lastPathComponent]);
    BOOL ret =[fileManager removeItemAtPath:fileName error:nil];
    if (ret){
      block(ret);
    }
  });
  
}
//
// 从eventes.plist 中删除item 在item 发送成功以后需要清空纪录
// 从eventes.plist 中删除对应项（文件名） 一般是在文件发送成功以后，需要删除文件并删除对应的eventes.plist项
//

+ (void) deleteItem:(NSString *) fileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docPath = [paths objectAtIndex:0];
  NSString *myFile = [docPath stringByAppendingPathComponent:@"eventes.plist"];
  NSMutableArray *events = [[NSMutableArray alloc] initWithContentsOfFile:myFile];
  if(events != nil){
    [events removeObject:fileName];
  }
  [events writeToFile:myFile atomically:YES];
}

//
// events.plist 中增加一项  产生新的文件，在events.plist中增加一条纪录
// 一般是 纪录事件的时候，当产生了新的纪录文件的时候需要在eventes.plist中新增一条纪录
// 

+ (void) appendItem:(NSString*) fileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docPath = [paths objectAtIndex:0];
  NSString *myFile = [docPath stringByAppendingPathComponent:@"eventes.plist"];
  NSMutableArray *events = [[NSMutableArray alloc] initWithContentsOfFile:myFile];
  if (events != nil) {
    [events addObject:fileName];
  }else{
    events = [[NSMutableArray alloc] initWithCapacity:10];
    [events addObject:fileName];
  }
  [events writeToFile:myFile atomically:YES];
}

/*  ----------------------------------------------------------------------
 *  
 *   以下是 json 字符串化方法
 *
 *  -----------------------------------------------------------------------
 */

//
// NSArray json 字符串化方法
//

+ (NSString *) jsonStringWithArray:(NSArray*) array{
  NSMutableString *reString = [NSMutableString string];
  @try {
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
      NSString *value = [DOUMobileStatUtils jsonStringWithObject:valueObj];
      if (value) {
        [values addObject:[NSString stringWithFormat:@"%@",value]];
      }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
  }
  @catch (NSException *exception) {
    DERRORLOG(@"exception: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
  return reString;
}

//
//  Dictionary json对象字符串
//

+(NSString *) jsonStringWithDictionary:(NSDictionary *) dictionary{
  NSMutableString *reString = [NSMutableString string];
  @try {
    NSArray *keys = [dictionary allKeys];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
      NSString *name = [keys objectAtIndex:i];
      id valueObj = [dictionary objectForKey:name];
      NSString *value = [self jsonStringWithObject:valueObj];
      if (value) {
        [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
      }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
  }
  @catch (NSException *exception) {
    DERRORLOG(@"exception: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
  return reString;
}

//
// NSString json对象字符串
//

+ (NSString *) jsonStringWithString:(NSString *) string{
  NSString *ret = nil;
  @try {
    ret = [NSString stringWithFormat:@"\"%@\"",
           [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
           ];
    return ret;
  }
  @catch (NSException *exception) {
    DERRORLOG(@"exception: %@", exception);
    
    NSAssert(NO, @"exception happends");
    return nil;
  }
}


+ (NSString *) urlEscapeString:(NSString *) unencodedString {
  
  NSParameterAssert(unencodedString != nil);
  NSParameterAssert([unencodedString isKindOfClass:[NSString class]]);
  if (![unencodedString isKindOfClass:[NSString class]]) {
    unencodedString = [NSString stringWithFormat:@"%@", unencodedString];
  }
  if (unencodedString == nil) {
    return @"";
  }
  
  CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
  NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL,
                                                                                      originalStringRef,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                      kCFStringEncodingUTF8 );
  CFRelease(originalStringRef);
  return s;
}


+ (NSString *) addQueryStringToUrlString:(NSString *) urlString withDictionary:(NSDictionary *) dictionary {
  
  NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
  for (id key in dictionary) {
    NSString *keyString = [key description];
    NSString *valueString = [[dictionary objectForKey:key] description];
    
    if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
      [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
    } else {
      [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
    }
  }
  return urlWithQuerystring;
}

//
// Object json对象字符串
//

+ (NSString *) jsonStringWithObject:(id) object{
  NSString *value = nil;
  if (!object) {
    return value;
  }
  if ([object isKindOfClass:[NSString class]]) {
    value = [DOUMobileStatUtils jsonStringWithString:object];
  }else if([object isKindOfClass:[NSDictionary class]]){
    value = [DOUMobileStatUtils jsonStringWithDictionary:object];
  }else if([object isKindOfClass:[NSArray class]]){
    value = [DOUMobileStatUtils jsonStringWithArray:object];
  }
  return value;
}


+ (BOOL) addSkipBackupAttributeToPath:(NSString *) filepath {
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO) {
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

+ (NSString *)localTimeStringForNow
{
  NSTimeInterval timeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
  return [NSString stringWithFormat:@"%.6f", timeIntervalSince1970];
}

#pragma mark - backgroud task

+ (void)startBackgroundTask
{
  if (globalBGTaskID != UIBackgroundTaskInvalid) {
    [self endBackgroundTaskByID:globalBGTaskID];
    globalBGTaskID = UIBackgroundTaskInvalid;
  }
  // block to use for timeout as well as completed task
  void (^completionBlock)() = ^{
    [[UIApplication sharedApplication] endBackgroundTask:globalBGTaskID];
    globalBGTaskID = UIBackgroundTaskInvalid;
  };
  
  globalBGTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:completionBlock];
}

+ (void)endBackgroundTask
{
  [self endBackgroundTaskByID:globalBGTaskID];
  globalBGTaskID = UIBackgroundTaskInvalid;
}

+ (void)endBackgroundTaskByID:(UIBackgroundTaskIdentifier)backgroundTaskID
{
  if (backgroundTaskID != UIBackgroundTaskInvalid) {
    [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskID];
  }
}

@end
