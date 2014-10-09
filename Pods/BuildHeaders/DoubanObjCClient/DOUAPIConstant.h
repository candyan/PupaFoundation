//
//  DOUAPIConfig.h
//  DOUAPIEngine
//
//  Created by Lin GUO on 11-11-1.
//  Copyright (c) 2011年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDoubanClientLibVersion;

//====== request block =========

@class DOUError;
@class DOUOAuth;
typedef void(^DOUAPIRequestSuccessBlock)();
typedef void(^DOUAPIRequestSuccessResultStrBlock)(NSString *resultStr);
typedef void(^DOUAPIRequestSuccessOAuthBlock)(DOUOAuth *oauth);
typedef void(^DOUAPIRequestFailErrorBlock)(DOUError *error);

typedef void(^successBlock)(); DEPRECATED_ATTRIBUTE // deprecated in 1.0.0. use DOUAPIRequestSuccessBlock instead.
typedef void(^failErrorBlock)(DOUError *error); DEPRECATED_ATTRIBUTE // deprecated in 1.0.0. use DOUAPIRequestFailErrorBlock instead.
typedef void(^successOAuthBlock)(DOUOAuth *oauth); DEPRECATED_ATTRIBUTE // deprecated in 1.0.0. use DOUAPIRequestSuccessOAuthBlock instead.

//====== Error Code ============
typedef enum _DoubanErrorCode{
  kDoubanErrorCodeNetworkTimeOut = -1009,
  kDoubanErrorCodeNeedPemission = 1000,
  kDoubanErrorCodeURLNotFound = 1001,
  kDoubanErrorCodeMissingArgs = 1002,
  kDoubanErrorCodeImageTooLarge = 1003,
  kDoubanErrorCodeHasBanWord = 1004,
  kDoubanErrorCodeInputTooShort = 1005,
  kDoubanErrorCodeTagretNotFound = 1006,
  kDoubanErrorCodeNeedCaptcha = 1007,
  kDoubanErrorCodeImageUnknow = 1008,
  kDoubanErrorCodeImageWrongFormat = 1009,
  kDoubanErrorCodeImageWrongCK = 1010,
  kDoubanErrorCodeImageCKExpired = 1011,
  kDoubanErrorCodeTitleMissing = 1012,
  kDoubanErrorCodeDescMissing = 1013,
  kDoubanErrorCodeWrongMethod = 1014,

/**** Douban Oauth2 Error code doc http://developers.douban.com/wiki/?title=oauth2 ****/
  kDoubanErrorCodeInvalidCredencial1 = 108,
  kDoubanErrorCodeUsernamePasswordMismatch = 120,
  kDoubanErrorCodeInvalidUser = 121,
  kDoubanErrorCodeUserBlocked = 122,
  kDoubanErrorCodeMissingAccessToken = 102,
  kDoubanErrorCodeInvalidAccessToken = 103,
  kDoubanErrorCodeAccessTokenHasExpired = 106,
  kDoubanErrorCodeRefreshTokenHasExpired = 119,
  kDoubanErrorCodeAccessTokenHasExpiredPC = 123,

} DoubanErrorCode;

//====== Notification =====
extern NSString * const kOAuthChangedNotification;

//====== API Base URL ============
extern NSString * const kDoubanAPIBaseURLString;
extern NSString * const kDoubanEtaBaseURLString;
extern NSString * const kDoubanOAuthBaseURLString;
extern NSString * const kDoubanArteryBaseURL;
extern NSString * const kDoubanSiteBaseURL;
extern NSString * const kDoubanZetaBaseURLString;

