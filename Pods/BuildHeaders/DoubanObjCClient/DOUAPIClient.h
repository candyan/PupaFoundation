//
//  DoubanObjCClient.h
//  DoubanObjCClient
//
//  Created by liu yan on 8/27/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "DOUAPIConstant.h"
#import "NSMutableDictionary+DOUObjCClient.h"
#import "DOUAPIRequestOperation.h"

@protocol DOUAPIErrorDelegate <NSObject>

- (void)receivedAPIError:(DOUError *)error;

@optional
- (void)requestErrorCode:(NSInteger)errorCode DEPRECATED_ATTRIBUTE; // deprecated in 1.0.0. use receivedAPIError: instead.

@end

/**
 DoubanAPIClient class declares an object that call douban api over http or https.
 It encapsulates parts of douban api and douban oauth.
*/
@class AFHTTPClient;
@class DOUError;

@interface DOUAPIClient : NSObject {
 @protected
  AFHTTPClient *_doubanAFClient;
}

/**
 The default params dictionary as the base params for request.
 */
@property (nonatomic, strong, readonly) NSDictionary *defaultParamters;

/**
 This is a request error delegate.
 */
@property (nonatomic, weak) id<DOUAPIErrorDelegate> errorDelegate;

///---------------------------------------------
/// @name Creating and Initializing Douban API Clients
///---------------------------------------------

/**
 Creates and initializes an `DoubanAPIClient` object with base url: https://api.douban.com/
 
 @return The newly-initialized Douban API client
 */
+ (DOUAPIClient *)sharedInstance;

/**
 Creates and initializes an `DoubanAPIClient` object with base url: https://zeta.douban.com/service/api/
 
 @return The newly-initialized Douban API client
 */
+ (DOUAPIClient *)sharedZetaInstance;

/**
 Initializes an `DoubanAPIClient` object with the specified base URL.This is the designated initializer.
 @param baseURL The base URL for the HTTP client. This argument must not be nil.
 @return The newly-initialized Douban API client
 */
- (id)initWithBaseUrl:(NSString *)baseURL DEPRECATED_ATTRIBUTE; // deprecated in 1.0.0. use initWithBaseURL: instead.
- (id)initWithBaseURL:(NSString *)baseURL;


///---------------------------------------------
/// @name Setting Client
///---------------------------------------------

/** 
 Set the Network Activity Indicator is enable. it can manage itself.
 
 @param enable A Boolean value indicating whether the Network Activity Indicator is enabled.
 */
+ (void)setNetworkActivityIndicatorEnable:(BOOL) enable;

/**
 Set the App Description.The App Description can use for all client. you need not set it for each client.
 @param appKey A NSString value This is a valid Douban API key.
 @param appSecret A NSString value This is a valid Douban Secret for the API key.
 @param appRedirectURL A NSString value This is a app redirect url which you provide to Douban for the API key.
 */
+ (void)setAppDescriptionWithAppKey:(NSString *)appKey
                          appSecret:(NSString *)appSecret
                     appRedirectURL:(NSString *)appRedirectURL;


+ (void)setOAuth:(DOUOAuth *)oauth;

/**
 Sets the value for the HTTP headers set in request objects made by the HTTP client. If `nil`, removes the existing value for that header.
 
 @param header The HTTP header to set a default value for
 @param value The value set as default for the specified header, or `nil
 */
- (void)setDefaultHeader:(NSString *)header value:(NSString *)value;

/**
 Add parameters to client for each request
 */
- (void)addDefaultParameters:(NSDictionary *)parameters;

/**
 Use json to encode body parameter or not.
 @param enabled : YES | NO, flag to identify if using json to encode body parameter
 */
- (void)setBodyParameterJSONEncodingEnabled:(BOOL)enabled;

///---------------------------------------------
/// @name Cancel operations
///---------------------------------------------

/**
 Canael all operations in currrent client.
 */
- (void)cancelAllOperationsInQueue;

/**
 Canael specific operations
 */
- (void)cancelOperationsWithMethod:(NSString *)httpMethod path:(NSString *)urlPath;

///---------------------------------------------
/// @name Reset client auth header
///---------------------------------------------

/**
 This Method can refresh current client http authorization header with stored token.
 */
- (void)refreshClientAuthHeader;

///---------------------------------------------
/// @name Verify the validity of client
///---------------------------------------------
/**
 This method is used to determine whether the client is valid。
 */
+ (BOOL)isValidClient;

///-------------------------------------------------
/// @name NSURLRequest For Auto Login Douban Web URL
///-------------------------------------------------
/**
 Creates a URLRequest with a web URL.if the url is in douban, the URLRequest can login account of douban with token at client.
 */
- (NSURLRequest *)requestForLoginWebURLAtDouban:(NSURL *)webURL;

@end

@interface DOUAPIClient (DOURESTRequest)

///---------------------------------------------
/// @name REST Request Method
///---------------------------------------------

/**
 This Method encapsulate AFHTTPClient getPath Mehtod. Increase the uniform error handling and default parameters.
 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(DOUAPIRequestSuccessResultStrBlock)success
        failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
 successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
        failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method encapsulate AFHTTPClient postPath Mehtod. Increase the uniform error handling and default parameters.
 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param uploadProgress A block to feedback the upload's progress.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected))progress
         success:(DOUAPIRequestSuccessResultStrBlock)success
         failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  uploadProgress:(void (^)(NSUInteger, long long, long long))progress
  successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
         failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method is an abbreviation of postPath:parameters:uploadProgres:success:failure Mehtod without uploadProgress.
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(DOUAPIRequestSuccessResultStrBlock)success
         failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
         failure:(DOUAPIRequestFailErrorBlock)failure;
/**
 This Method encapsulate AFHTTPClient putPath Mehtod. Increase the uniform error handling and default parameters.
 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(DOUAPIRequestSuccessBlock)success
        failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
 successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
        failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method encapsulate AFHTTPClient deletePath Mehtod. Increase the uniform error handling and default parameters.
 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(DOUAPIRequestSuccessBlock)success
           failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
    successRequest:(void (^)(DOUAPIRequestOperation *requstOperation))success
           failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method encapsulate AFHTTPClient postMultipartFormWithPath Mehtod. Increase the uniform error handling and default parameters.
 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param constructingBodyWithBlock A block to construct the data to upload.
 @param uploadProgress A block to feedback the upload's progress.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                   uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected))progress
                          success:(DOUAPIRequestSuccessResultStrBlock)success
                          failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                   uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected))progress
                   successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
                          failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method is an abbreviation of postMultipartFormWithPath:parameters:constructingBodyWithBlock:uploadProgres:success:failure Mehtod without uploadProgress.
 */
- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                          success:(DOUAPIRequestSuccessResultStrBlock)success
                          failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                   successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
                          failure:(DOUAPIRequestFailErrorBlock)failure;

/**
 This Method encapsulate AFHTTPClient patchPath Mehtod. Increase the uniform error handling and default parameters.

 @param path The path to be appended to the HTTP client’s base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the NSError object describing the network or parsing error that occurred.
 */
- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
          success:(DOUAPIRequestSuccessResultStrBlock)success
          failure:(DOUAPIRequestFailErrorBlock)failure;

- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
   successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
          failure:(DOUAPIRequestFailErrorBlock)failure;

@end
