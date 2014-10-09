//
//  DOUAPIClient+DOURESTRequest.m
//  DoubanObjCClient
//
//  Created by liuyan on 13-11-8.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

#import "AFHTTPRequestOperation.h"
#import "DOUError.h"
#import "DOUAPIClient+Private.h"

@implementation DOUAPIClient (DOURESTRequest)

#pragma mark - GET Request

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(DOUAPIRequestSuccessResultStrBlock)success
        failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self getPath:path parameters:parameters successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation) {
    if (success) {
      success(resultStr);
    }
  } failure:failure];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
 successRequest:(void (^)(NSString *, DOUAPIRequestOperation *))success
        failure:(DOUAPIRequestFailErrorBlock)failure
{
  path = [self _pathWithDefaultParametersToPathIfNeeded:path];
  parameters = [self _parametersWithDefaultParametersToParameters:parameters];

  [_doubanAFClient getPath:path
                parameters:parameters
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
    DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
     if (success) {
       success(operation.responseString, requestOperation);
     }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DOUError *requestError = [DOUError objectWithString:operation.responseString];
     [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                 handleBlock:failure];
   }];
}

#pragma mark - POST Request

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(DOUAPIRequestSuccessResultStrBlock)success
         failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postPath:path
      parameters:parameters
  uploadProgress:nil
         success:success
         failure:failure];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected))progress
         success:(DOUAPIRequestSuccessResultStrBlock)success
         failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postPath:path
      parameters:parameters
  uploadProgress:progress
  successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation) {
    if (success) {
      success(resultStr);
    }
  } failure:failure];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  successRequest:(void (^)(NSString *, DOUAPIRequestOperation *))success
         failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postPath:path
      parameters:parameters
  uploadProgress:nil
  successRequest:success
         failure:failure];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
  uploadProgress:(void (^)(NSUInteger, long long, long long))progress
  successRequest:(void (^)(NSString *, DOUAPIRequestOperation *))success
         failure:(DOUAPIRequestFailErrorBlock)failure
{
  path = [self _pathWithDefaultParametersToPathIfNeeded:path];
  parameters = [self _parametersWithDefaultParametersToParameters:parameters];
  // successBlock
  void (^successBlock)(AFHTTPRequestOperation *, id);
  successBlock = ^(AFHTTPRequestOperation * operation, id responseObject) {
    DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
    if (success) {
      success(operation.responseString, requestOperation);
    }
  };

  // failureBlock
  void (^failureBlock)(AFHTTPRequestOperation *, NSError *);
  failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
    DOUError *requestError = [DOUError objectWithString:operation.responseString];
    [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                handleBlock:failure];
  };
  
  NSURLRequest *request = [_doubanAFClient requestWithMethod:@"POST" path:path parameters:parameters];
	AFHTTPRequestOperation *operation = [_doubanAFClient HTTPRequestOperationWithRequest:request
                                                                               success:successBlock
                                                                               failure:failureBlock];
  // uploadProgress
  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected) {
    if (progress) {
      progress(bytesWritten, totalBytes, totalBytesExpected);
    }
  }];

  [_doubanAFClient enqueueHTTPRequestOperation:operation];
}


- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(DOUAPIRequestSuccessBlock)success
        failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self putPath:path
     parameters:parameters
 successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation) {
   if (success) {
      success();
    }
  } failure:failure];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
 successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
        failure:(DOUAPIRequestFailErrorBlock)failure
{
  path = [self _pathWithDefaultParametersToPathIfNeeded:path];
  parameters = [self _parametersWithDefaultParametersToParameters:parameters];
  [_doubanAFClient putPath:path
                parameters:parameters
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
    DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
     if (success) {
       success(operation.responseString, requestOperation);
     }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error){
     DOUError *requestError = [DOUError objectWithString:operation.responseString];
     [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                 handleBlock:failure];
   }];
}

#pragma mark - POST Multipart Request

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                          success:(void (^)(NSString *))success
                          failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postMultipartFormWithPath:path parameters:parameters
        constructingBodyWithBlock:block
                   uploadProgress:nil
                          success:success
                          failure:failure];
}

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                   uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected))progress
                          success:(void (^)(NSString *))success
                          failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postMultipartFormWithPath:path
                       parameters:parameters
        constructingBodyWithBlock:block
                   uploadProgress:progress
                   successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation)
  {
    if (success) {
      success(resultStr);
    }
  } failure:failure];
}

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                   successRequest:(void (^)(NSString *, DOUAPIRequestOperation *))success
                          failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self postMultipartFormWithPath:path
                       parameters:parameters
        constructingBodyWithBlock:block
                   uploadProgress:nil
                   successRequest:success
                          failure:failure];
}

- (void)postMultipartFormWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                   uploadProgress:(void (^)(NSUInteger, long long, long long))progress
                   successRequest:(void (^)(NSString *, DOUAPIRequestOperation *))success
                          failure:(DOUAPIRequestFailErrorBlock)failure
{
  NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionaryWithDictionary:self.defaultParamters];
  [finalDictionary addEntriesFromDictionary:parameters];

  NSMutableURLRequest *request = [_doubanAFClient multipartFormRequestWithMethod:@"POST"
                                                                            path:path
                                                                      parameters:finalDictionary
                                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                    if (block) {
                                      block(formData);
                                    }
                                  }];

  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
    if (success) {
      success(operation.responseString, requestOperation);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    DOUError *requestError = [DOUError objectWithString:operation.responseString];
    [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                handleBlock:failure];
  }];

  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytes, long long totalBytesExpected) {
    if (progress) {
      progress(bytesWritten, totalBytes, totalBytesExpected);
    }
  }];

  [_doubanAFClient enqueueHTTPRequestOperation:operation];
}

#pragma mark - DELETE Request

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(DOUAPIRequestSuccessBlock)success
           failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self deletePath:path
        parameters:parameters
    successRequest:^(DOUAPIRequestOperation *requstOperation)
  {
    if (success) {
      success();
    }
  } failure:failure];
}

-(void)deletePath:(NSString *)path
       parameters:(NSDictionary *)parameters
   successRequest:(void (^)(DOUAPIRequestOperation *))success
          failure:(DOUAPIRequestFailErrorBlock)failure
{
  path = [self _pathWithDefaultParametersToPathIfNeeded:path];
  parameters = [self _parametersWithDefaultParametersToParameters:parameters];
  [_doubanAFClient deletePath:path
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
     DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
     if (success) {
       success(requestOperation);
     }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error){
     DOUError *requestError = [DOUError objectWithString:operation.responseString];
     [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                 handleBlock:failure];
   }];
}

#pragma mark - PATCH Request

- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
          success:(DOUAPIRequestSuccessResultStrBlock)success
          failure:(DOUAPIRequestFailErrorBlock)failure
{
  [self patchPath:path
       parameters:parameters
   successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation)
  {
    if (success) {
      success(resultStr);
    }
  } failure:failure];
}

- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
   successRequest:(void (^)(NSString *resultStr, DOUAPIRequestOperation *requstOperation))success
          failure:(DOUAPIRequestFailErrorBlock)failure
{
  path = [self _pathWithDefaultParametersToPathIfNeeded:path];
  parameters = [self _parametersWithDefaultParametersToParameters:parameters];
  [_doubanAFClient patchPath:path
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
    DOUAPIRequestOperation *requestOperation = [[DOUAPIRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
    if (success) {
      success(operation.responseString, requestOperation);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    DOUError *requestError = [DOUError objectWithString:operation.responseString];
    [self handleClientError:((requestError != nil) ? requestError : [DOUError douError:error])
                handleBlock:failure];
  }];
}

#pragma mark - Private methods


- (NSString *)_pathWithDefaultParametersToPathIfNeeded:(NSString *)path
{
  NSParameterAssert(path != nil);
  if (_doubanAFClient.parameterEncoding == AFJSONParameterEncoding) {
    path = [path stringByAppendingFormat:@"%@%@",
             [path rangeOfString:@"?"].location == NSNotFound ? @"?" : @"&",
             AFQueryStringFromParametersWithEncoding(self.defaultParamters, NSUTF8StringEncoding)
             ];
  }
  return path;
}

- (NSDictionary *)_parametersWithDefaultParametersToParameters:(NSDictionary *)parameters
{
  if (_doubanAFClient.parameterEncoding != AFJSONParameterEncoding) {
    if (parameters == nil) {
      parameters = [self.defaultParamters copy];
    } else {
      NSMutableDictionary *finalDictionary = [self.defaultParamters mutableCopy];
      [finalDictionary addEntriesFromDictionary:parameters];
      parameters = finalDictionary;
    }
  }
  return parameters;
}

@end
