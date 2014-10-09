//
//  DOUError.m
//  DoubanObjCClient
//
//  Created by GUO Lin on 12/21/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUError.h"
#import "DOUAPIConstant.h"

NSString * const kDOUErrorDomain = @"DOUErrorDomain";

static NSInteger const kDOUClientErrorMaxOauthErrorCode = 999;
static NSInteger const kDOUClientErrorMinOauthErrorCode = 100;

@interface DOUError ()
@property (nonatomic, strong, readwrite) NSString *errorDomain;
@end

@implementation DOUError

@dynamic errorCode;
@dynamic errorMsg;
@dynamic errorRequest;
@dynamic oAuthError;

- (id)init {
  self = [super init];
  if (self) {
    self.errorDomain = kDOUErrorDomain;
  }
  return  self;
}

#pragma mark - Getter & Setter

- (NSInteger)errorCode {
  return [[self.dictionary objectForKey:@"code"] integerValue];
}

- (void)setErrorCode:(NSInteger)errorCode
{
  [self.dictionary setObject:[NSNumber numberWithInteger:errorCode] forKey:@"code"];
}

- (NSString *)errorMsg {
  return [self.dictionary objectForKey:@"msg"];
}

- (void)setErrorMsg:(NSString *)errorMsg {
  [self.dictionary setValue:errorMsg forKey:@"msg"];
}

- (NSString *)errorRequest {
  return [self.dictionary objectForKey:@"request"];
}

- (void)setErrorRequest:(NSString *)errorRequest {
  [self.dictionary setValue:errorRequest forKey:@"request"];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@, %d, %@", [self errorDomain], [self errorCode], [self errorMsg]];
}

#pragma mark - Other Mehods
-(DOUClientOAuthError)oAuthError
{
  NSInteger errorCode = self.errorCode;
  DOUClientOAuthError error = kDOUClientOAuthErrorNone;
  if ([self.errorDomain isEqualToString:kDOUErrorDomain]
      && errorCode <= kDOUClientErrorMaxOauthErrorCode
      && errorCode >= kDOUClientErrorMinOauthErrorCode) {
    switch (errorCode) {
      case kDoubanErrorCodeUsernamePasswordMismatch:
          error = kDOUClientOAuthErrorPasswordWrong;
        break;
      case kDoubanErrorCodeMissingAccessToken:
          error = kDOUClientOAuthErrorAccessTokenWrong;
        break;
      case kDoubanErrorCodeInvalidAccessToken:
          error = kDOUClientOAuthErrorAccessTokenWrong;
        break;
      case kDoubanErrorCodeAccessTokenHasExpired:
          error = kDOUClientOAuthErrorAccessTokenExpired;
        break;
      case kDoubanErrorCodeAccessTokenHasExpiredPC:
          error = kDOUClientOAuthErrorAccessTokenExpired;
        break;
      case kDoubanErrorCodeRefreshTokenHasExpired:
          error = kDOUClientOAuthErrorRefreshTokenExpired;
        break;
      default:
          error = kDOUClientOAuthErrorOther;
    }
  }
  return error;
}

+ (DOUError *)douError:(NSError *)error {
  DOUError *douError = [[DOUError alloc] init];
  douError.errorDomain = error.domain;
  douError.errorCode = error.code;
  douError.errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
  douError.errorRequest = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
  return douError;
}

@end
