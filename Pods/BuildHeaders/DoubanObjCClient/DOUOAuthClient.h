//
//  DoubanAPIClient+XAuth.h
//  DoubanAPIClient
//
//  Created by liu yan on 8/28/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import "DOUAPIConstant.h"
#import "DOUAPIClient.h"

@class DOUOAuth;
@interface DOUOAuthClient : DOUAPIClient

+ (DOUOAuthClient *)sharedInstance;

/**
 This Method request to XAuth with username and password.
 */
- (void)fetchAccessTokenWithUsername:(NSString *)username
                           password:(NSString *)password
                            success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                            failure:(DOUAPIRequestFailErrorBlock)failureBlock;

/**
 AuthorizationCode
 */
- (void)fetchAccessTokenWithAuthorizationCode:(NSString *)authorizationCode
                                      success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                      failure:(DOUAPIRequestFailErrorBlock)failureBlock;

/**
 This Method requset to Refresh Token.
 */
- (void)refreshAccessToken:(DOUAPIRequestSuccessOAuthBlock)success
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock;

- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                   success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                   failure:(DOUAPIRequestFailErrorBlock)failureBlock;

/**
 This method fetch AccessToken with OpenId
 @param openId openId.
 @param source Your app come from which product: "group", "waymeet", "book" ... This API is open only for douban app.
 @param openIdAppId Your AppKey from third plateform like sinaweibo, QQ, MSN ...
 @param openIdType SinaWeibo:104, QQ:103, MSN: 105, RENREN:106, KAIXIN:107
 @param openIdAccessToken The accessToken which you obtain from client platform.
 */
- (void)fetchAccessTokenWithOpenId:(NSString *)openId
                            source:(NSString *)source
                       openIdAppId:(NSString *)openIdAppId
                        openIdType:(NSString *)openIdType
                 openIdAccessToken:(NSString *)openIdAccessToken
                           success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                           failure:(DOUAPIRequestFailErrorBlock)failureBlock;

/**
 Exchange Token
 */
- (void)fetchAccessTokenWithExchangeToken:(NSString *)exchangeToken
                                  success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                                  failure:(DOUAPIRequestFailErrorBlock)failureBlock;

/**
 Register LoginCode Fetch Token
 */
- (void)fetchAccessTokenWithLoginCode:(NSString *)loginCode
                              success:(DOUAPIRequestSuccessOAuthBlock)successBlock
                              failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
