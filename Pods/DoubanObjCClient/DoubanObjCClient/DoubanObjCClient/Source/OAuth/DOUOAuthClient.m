//
//  DoubanAPIClient+XAuth.m
//  DoubanAPIClient
//
//  Created by Candyan on 8/28/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import "DOUOAuthClient.h"
#import "DOUAPIClient+Private.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "DOUAPIConstant.h"
#import "DOUOAuth.h"
#import "DOUError.h"
#import "DOUAppDescription.h"
#import "DOUOAuthManager.h"
#import "DOUSharedUDID.h"

@implementation DOUOAuthClient

#pragma mark - Instance

+ (id)sharedInstance
{
  static DOUOAuthClient *myInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    myInstance = [[DOUOAuthClient alloc] initWithBaseURL:kDoubanOAuthBaseURLString];
  });
  return myInstance;
}

#pragma mark - Access Token Method

- (void)fetchAccessTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                             success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                             failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"password",
                              @"username": username,
                              @"password": password};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *auth) {
    if (successBlock) {
      successBlock(auth);
    }
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)fetchAccessTokenWithAuthorizationCode:(NSString *)authorizationCode
                                      success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                      failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"authorization_code",
                             @"code": authorizationCode};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *auth) {
    if (successBlock) {
      successBlock(auth);
    }
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)refreshAccessToken:(DOUAPIRequestSuccessOAuthBlock)successBlock
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  [self refreshAccessTokenWithRefreshToken:[DOUOAuthManager sharedInstance].currentOAuth.refreshToken
                                   success:successBlock
                                   failure:failureBlock];
}

- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                   success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                   failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"refresh_token",
                              @"refresh_token": refreshToken};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *oauth) {
    if (successBlock) {
      successBlock(oauth);
    }
    
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}


- (void)fetchAccessTokenWithOpenId:(NSString *)openId
                            source:(NSString *)source
                       openIdAppId:(NSString *)openIdAppId
                        openIdType:(NSString *)openIdType
                 openIdAccessToken:(NSString *)openIdAccessToken
                           success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                           failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"openid",
                              @"openid": openId,
                              @"source": source,
                              @"openid_appid": openIdAppId,
                              @"openid_type": openIdType,
                              @"openid_access_token": openIdAccessToken};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *oauth) {
    if (successBlock) {
      successBlock(oauth);
    }
    
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)fetchAccessTokenWithExchangeToken:(NSString *)exchangeToken
                                  success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                  failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"exchange_token",
                              @"exchange_token": exchangeToken};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *auth) {
    if (successBlock) {
      successBlock(auth);
    }
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)fetchAccessTokenWithLoginCode:(NSString *)loginCode
                              success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                              failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSDictionary *paramters = @{@"grant_type": @"web_register",
                              @"login_code": loginCode};
  
  [self _fetchAccessTokenWithParamters:paramters success:^(DOUOAuth *auth) {
    if (successBlock) {
      successBlock(auth);
    }
  }failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

#pragma mark - Private

- (void)_fetchAccessTokenWithParamters:(NSDictionary *)paramters
                               success:(DOUAPIRequestSuccessBlock)successBlock
                               failure:(DOUAPIRequestFailErrorBlock)failureBlock
{ 
  NSMutableDictionary *authDictionary = [NSMutableDictionary dictionaryWithDictionary:paramters];
  [authDictionary setObject:[DOUAppDescription currentAppDescription].appKey forKey:@"client_id"];
  [authDictionary setObject:[DOUAppDescription currentAppDescription].appSecret forKey:@"client_secret"];
  [authDictionary setObject:[DOUAppDescription currentAppDescription].appRedirectURL forKey:@"redirect_uri"];
  [authDictionary setObject:[NSString stringWithFormat:@"%d", arc4random() % 100000]
                     forKey:@"?_v"];
  
  [self postPath:@"auth2/token" parameters:authDictionary success:^(NSString *resultStr) {
    DOUOAuth *oauth = [DOUOAuth objectWithString:resultStr];
    [DOUAPIClient setOAuth:oauth];
    if (successBlock) {
      successBlock(oauth);
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
