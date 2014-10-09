//
//  DOUError.h
//  DoubanObjCClient
//
//  Created by GUO Lin on 12/21/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

extern NSString * const kDOUErrorDomain;

typedef NS_ENUM(NSUInteger, DOUClientOAuthError) {
  kDOUClientOAuthErrorNone = 0,
  kDOUClientOAuthErrorPasswordWrong,
  kDOUClientOAuthErrorAccessTokenWrong,
  kDOUClientOAuthErrorAccessTokenExpired,
  kDOUClientOAuthErrorRefreshTokenExpired,
  kDOUClientOAuthErrorOther,
};

@interface DOUError : DOUObject

@property (nonatomic, strong, readonly) NSString *errorDomain;
@property (nonatomic, assign, readonly) NSInteger errorCode;
@property (nonatomic, strong, readonly) NSString *errorMsg;
@property (nonatomic, strong, readonly) NSString *errorRequest;
@property (nonatomic, assign, readonly) DOUClientOAuthError oAuthError;

+ (DOUError *)douError:(NSError *)error;
@end
