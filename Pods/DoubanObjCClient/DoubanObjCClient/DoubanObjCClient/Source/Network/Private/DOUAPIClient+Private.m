//
//  DOUAPIClient+Private.m
//  DoubanObjCClient
//
//  Created by Jianjun Wu on 4/23/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//
#import "DOUAPIClient+Private.h"
#import "DOUError.h"

#include <sys/sysctl.h>
#import <UIKit/UIKit.h>

@implementation DOUAPIClient (Private)

#pragma mark - User Agent

- (void)addUserAgentHeaderToClient
{
    
  [_doubanAFClient setDefaultHeader:@"User-Agent" value:[DOUAPIClient _clientUserAgent]];
}

+ (NSString *)_clientUserAgent
{
  static NSString * clientUserAgentStr = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * bundleID = [[bundle infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    NSString * shortVersion = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *deviceName = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    
    NSAssert(bundleID != nil, @"bundleID should not be nil");
    NSAssert(shortVersion != nil, @"bundleVersion should not be nil");
    NSAssert(systemVersion != nil, @"systemVersion should not be nil");
    NSAssert(deviceName != nil, @"deviceName should not be nil");
    clientUserAgentStr = [NSString stringWithFormat:@"api-client/%@ %@/%@ iOS/%@ %@",
                          kDoubanClientLibVersion, bundleID, shortVersion, systemVersion, deviceName];
  });
  return clientUserAgentStr;
}

#pragma mark - Handle Error

- (void)handleClientError:(DOUError *)error handleBlock:(DOUAPIRequestFailErrorBlock)handleBlock
{
  if (handleBlock) handleBlock(error);
  [self _parseRequestError:error];
}

- (void)_parseRequestError:(DOUError *)requestError
{
  NSLog(@"error code: %i, msg: %@, uri: %@", requestError.errorCode, requestError.errorMsg, requestError.errorRequest);
  if ([self.errorDelegate respondsToSelector:@selector(receivedAPIError:)]) {
    [self.errorDelegate receivedAPIError:requestError];
  }
}

@end
