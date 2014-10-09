//
//  DOUUserManagerUtil.m
//  DOUUserManager
//
//  Created by Jianjun Wu on 3/27/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUUserManagerUtil.h"
#include <sys/xattr.h>

@implementation DOUUserManagerUtil

+ (BOOL)addSkipBackupAttributeToPath:(NSString *)filepath {
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO) {
    NSLog(@"File path not exist in addSkipBackupAttributeToPath:");
    return NO;
  }
  
  float version = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (version < 5.f) {
    return YES;
  }
  
  const char * attrName = NULL;
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

@end
