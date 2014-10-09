//
//  DOUAPIClient.h
//  DoubanObjCClient
//
//  Created by Candyan on 8/27/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//
#include <sys/sysctl.h>
#import "DOUAPIClient.h"
#import "DOUAPIConstant.h"
#import "DOUOAuthClient.h"
#import "DOUOAuth.h"
#import "DOUError.h"
#import "DOUAppDescription.h"
#import "DOUOAuthManager.h"
#import "DOUSharedUDID.h"
#import "DOUAPIClient+Private.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPRequestOperation.h"

@interface DOUAPIClient ()

/**
 This is an AFHTTPClient Object.
 */
@property (nonatomic, retain) AFHTTPClient *doubanAFClient;

@end

@implementation DOUAPIClient

@synthesize doubanAFClient = _doubanAFClient;
@synthesize defaultParamters = _defaultParamters;

#pragma mark - Shared Instance

+ (DOUAPIClient *)sharedInstance
{
  static DOUAPIClient *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DOUAPIClient alloc] initWithBaseURL:kDoubanAPIBaseURLString];
  });
  return sharedInstance;
}

+ (DOUAPIClient *)sharedZetaInstance
{
  static DOUAPIClient *sharedZetaInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedZetaInstance = [[DOUAPIClient alloc] initWithBaseURL:kDoubanZetaBaseURLString];
  });
  return sharedZetaInstance;
}

#pragma mark - init

- (id)initWithBaseUrl:(NSString *)baseURL
{
  return [self initWithBaseURL:baseURL];
}

- (id)initWithBaseURL:(NSString *)baseURL
{
  NSAssert([DOUAPIClient isValidClient], @"The client must have apiKey, apiSectect & apiRedirURL.");
  self = [super init];
  if (self) {
    _doubanAFClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    [self addUserAgentHeaderToClient];
    [self refreshClientAuthHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshClientAuthHeader)
                                                 name:kOAuthChangedNotification
                                               object:nil];
  }
  return self;
}

#pragma mark - dealloc

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - prop

- (NSDictionary *)defaultParamters
{
  if (_defaultParamters == nil) {
    NSMutableDictionary *defaultMutableParams = [NSMutableDictionary dictionary];
    [defaultMutableParams setValue:@"json" forKey:@"alt"];
    [defaultMutableParams setValue:[DOUAppDescription currentAppDescription].appKey forKey:@"apikey"];
    [defaultMutableParams setValue:[DOUSharedUDID sharedUDID] forKey:@"udid"];
    _defaultParamters = [defaultMutableParams copy];
  }
  return _defaultParamters;
}

#pragma mark - Set
+ (void)setNetworkActivityIndicatorEnable:(BOOL)enable
{
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:enable];
}

- (void)setDefaultHeader:(NSString *)header value:(NSString *)value
{
  [_doubanAFClient setDefaultHeader:header value:value];
}

- (void)addDefaultParameters:(NSDictionary *)extraParameters
{
  NSMutableDictionary *params = [[self defaultParamters] mutableCopy];
  [params addEntriesFromDictionary:extraParameters];
  _defaultParamters = [[NSDictionary alloc] initWithDictionary:params];
}

- (void)setBodyParameterJSONEncodingEnabled:(BOOL)enabled
{
  if (enabled) {
    _doubanAFClient.parameterEncoding = AFJSONParameterEncoding;
  } else {
    _doubanAFClient.parameterEncoding = AFFormURLParameterEncoding;
  }
}

+ (void)setAppDescriptionWithAppKey:(NSString *)appKey
                          appSecret:(NSString *)appSecret
                     appRedirectURL:(NSString *)appRedirectURL
{
  [DOUAppDescription setAppDescriptionWithAppKey:appKey appSecret:appSecret appRedirectURL:appRedirectURL];
}

+ (void)setOAuth:(DOUOAuth *)oauth
{
  [[DOUOAuthManager sharedInstance] setCurrentOAuth:oauth];
  [[NSNotificationCenter defaultCenter] postNotificationName:kOAuthChangedNotification object:nil];
}

#pragma mark - Cancel

- (void)cancelAllOperationsInQueue
{
  [_doubanAFClient.operationQueue cancelAllOperations];
}

- (void)cancelOperationsWithMethod:(NSString *)httpMethod path:(NSString *)urlPath
{
  [_doubanAFClient cancelAllHTTPOperationsWithMethod:httpMethod path:urlPath];
}

#pragma mark - Refresh Authorization Header

- (void)refreshClientAuthHeader
{
  if ([self.doubanAFClient.baseURL.absoluteString hasPrefix:@"https"]) {
    if ([DOUOAuthManager sharedInstance].currentOAuth) {
      [self _setDoubanAuthorizationHeaderWithToken:[DOUOAuthManager sharedInstance].currentOAuth.accessToken];
    } else {
      [self.doubanAFClient clearAuthorizationHeader];
    }
  }
}

#pragma mark - util
+ (BOOL)isValidClient
{
  if ([DOUAppDescription currentAppDescription].appKey &&
      [DOUAppDescription currentAppDescription].appSecret &&
      [DOUAppDescription currentAppDescription].appRedirectURL) {
    return YES;
  } else {
    return NO;
  }
}

- (NSURLRequest *)requestForLoginWebURLAtDouban:(NSURL *)webURL
{
  if ([DOUOAuthManager sharedInstance].currentOAuth) {
    NSString *requestURLFormat = @"https://www.douban.com/accounts/auth2_redir?url=%@&apikey=%@";
    NSString *requestPath = [NSString stringWithFormat:requestURLFormat, [webURL.absoluteString encodingStringUsingURLEscape], [DOUAppDescription currentAppDescription].appKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [DOUOAuthManager sharedInstance].currentOAuth.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPShouldHandleCookies:YES];
    
    return request;
  } else {
    return [NSURLRequest requestWithURL:webURL];
  }
}

#pragma mark - Private
- (void)_setDoubanAuthorizationHeaderWithToken:(NSString *)token
{
  [self.doubanAFClient setDefaultHeader:@"Authorization"
                                  value:[NSString stringWithFormat:@"Bearer %@", token]];
}

@end
