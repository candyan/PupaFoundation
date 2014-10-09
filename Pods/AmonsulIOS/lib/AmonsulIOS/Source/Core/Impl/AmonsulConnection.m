//
//  AmonsulConnection.m
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AmonsulConnection.h"
#import "DOUMobileStatUtils.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "DOUMobileStatImp.h"
#import "DOUStatConstant.h"

const NSTimeInterval kAmonsuleNetworkTimeout = 20.0;

typedef void (^AmonsulConnectionBasicBlock)(AmonsulConnection *conn);

@interface AmonsulConnection ()
@property (nonatomic, copy) AmonsulConnectionBasicBlock succeedBlock;
@property (nonatomic, copy) AmonsulConnectionBasicBlock failureBlock;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong, readwrite) NSMutableData *buf;
@end

@implementation AmonsulConnection

- (void)  get:(NSString *)urlPath
  queryParams:(NSDictionary *)params
        async:(BOOL)isAsync
      succeed:(void (^)(AmonsulConnection *conn))completedBlock
      failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  if (isAsync) {
    if ([NSThread isMainThread]) {
      [self get:urlPath queryParams:params succeed:completedBlock failure:failureBlock];
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self get:urlPath queryParams:params succeed:completedBlock failure:failureBlock];
      });
    }
  } else {
    [self syncGet:urlPath queryParams:params succeed:completedBlock failure:failureBlock];
  }
}

- (void)post:(NSString *)aURL
        body:(NSString *)body
       async:(BOOL)isAsync
     succeed:(void (^)(AmonsulConnection *conn))completedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  if (isAsync) {
    if ([NSThread isMainThread]) {
      [self post:aURL body:body succeed:completedBlock failure:failureBlock];
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self post:aURL body:body succeed:completedBlock failure:failureBlock];
      });
    }
  } else {
    [self syncPost:aURL body:body succeed:completedBlock failure:failureBlock];
  }
}

- (void)post:(NSString *)aURL
       async:(BOOL)isAsync
     succeed:(void (^)(AmonsulConnection *conn))completedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  [self post:aURL body:nil async:isAsync succeed:completedBlock failure:failureBlock];
}

- (void)sendRequeset:(NSURLRequest *)request
               async:(BOOL)isAsync
             succeed:(void (^)(AmonsulConnection *conn))completedBlock
             failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  self.requestURL = request.URL.absoluteString;
  self.succeedBlock = completedBlock;
  self.failureBlock = failureBlock;
  
  if (isAsync) {
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.connection) {
      self.buf = [NSMutableData data];
    }
  } else {
    [self sendSyncRequestAndCallFinishMethod:request];
  }
}

#pragma mark - aync api
- (void)  get:(NSString *)urlPath
  queryParams:(NSDictionary *)params
      succeed:(void (^)(AmonsulConnection *conn))succeedBlock
      failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  self.requestURL = [DOUMobileStatUtils addQueryStringToUrlString:urlPath withDictionary:params];
  self.succeedBlock = succeedBlock;
  self.failureBlock = failureBlock;
  
  NSMutableURLRequest *request = [self getRequestForURL:urlPath];
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  if (self.connection) {
    self.buf = [NSMutableData data];
  }
}

- (void)post:(NSString *)urlPath
     succeed:(void (^)(AmonsulConnection *conn))succeedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  [self post:urlPath body:nil succeed:succeedBlock failure:failureBlock];
}

- (void)post:(NSString *)urlPath
        body:(NSString *)body
     succeed:(void (^)(AmonsulConnection *conn))succeedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  self.requestURL = urlPath;
  self.succeedBlock = succeedBlock;
  self.failureBlock = failureBlock;
  
  NSMutableURLRequest *request = [self postRequestForURL:urlPath];
  if (body != nil) {
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
  }
  self.buf = [NSMutableData data];
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - sync http api
- (void)syncGet:(NSString *)urlPath
    queryParams:(NSDictionary *)params
        succeed:(void (^)(AmonsulConnection *conn))completedBlock
        failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  self.requestURL = urlPath;
  self.succeedBlock = completedBlock;
  self.failureBlock = failureBlock;
  
  NSMutableURLRequest *request = [self getRequestForURL:urlPath];
  [self sendSyncRequestAndCallFinishMethod:request];
}

- (void)syncPost:(NSString *)urlPath
            body:(NSString *)body
         succeed:(void (^)(AmonsulConnection *conn))completedBlock
         failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  self.requestURL = urlPath;
  self.succeedBlock = completedBlock;
  self.failureBlock = failureBlock;
  
  NSMutableURLRequest *request = [self postRequestForURL:urlPath];
  if (body != nil) {
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
  }
  
  [self sendSyncRequestAndCallFinishMethod:request];
}

- (void)syncPost:(NSString *)urlPath
         succeed:(void (^)(AmonsulConnection *conn))completedBlock
         failure:(void (^)(AmonsulConnection *conn))failureBlock
{
  [self syncPost:urlPath body:nil succeed:completedBlock failure:failureBlock];
}

#pragma mark - util methods
- (NSMutableURLRequest *)postRequestForURL:(NSString *)urlStr
{
  NSMutableURLRequest *request = [NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:urlStr]
                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                  timeoutInterval:kAmonsuleNetworkTimeout];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  return request;
}

- (NSMutableURLRequest *)getRequestForURL:(NSString *)urlStr
{
  NSMutableURLRequest *request = [NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:urlStr]
                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:kAmonsuleNetworkTimeout];
  [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  return request;
}

- (void)sendSyncRequestAndCallFinishMethod:(NSURLRequest *)request
{
  NSHTTPURLResponse *response = nil;
  NSError *err = nil;
  NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
  self.error = err;
  self.response = response;
  self.buf = [respData mutableCopy];
  [self handleWhenConnectionDidFinish];
}

- (void)handleWhenConnectionDidFinish
{
  if (self.error) {
    [self requestDidFail:self.error];
  } else if (self.response.statusCode <= 300) {
    [self requestDidSucceed];
  } else {
    [self requestDidFail:[NSError errorWithDomain:@"com.douban.common.amonsul.http"
                                             code:self.response.statusCode
                                         userInfo:nil]];
  }
  self.connection = nil;
}

#pragma mark -
//
// NSURLConnection's delegate:
//
- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)aResponse
{
  NSHTTPURLResponse *response = (NSHTTPURLResponse *)aResponse;
  if (response) {
    DTRACELOG(@"response code = %d", response.statusCode);
  }
  [self.buf setData:nil];
  self.response = response;
}

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
  [self.buf appendData:data];
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
  DTRACELOG(@"failed...");
  self.error = error;
  [self requestDidFail:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
  [self handleWhenConnectionDidFinish];
}

- (void)requestDidSucceed
{
  DTRACELOG(@"network connection did finish loading");
  if (self.succeedBlock) {
    self.succeedBlock(self);
  }
}

- (void)requestDidFail:(NSError *)error
{
  DTRACELOG(@"error = %@", error);
  if (self.failureBlock) {
    self.failureBlock(self);
  }
}

- (NSString *)fecthResponseString
{
  NSString *responseStr = [[NSString alloc] initWithData:self.buf encoding:NSUTF8StringEncoding];
  return responseStr;
}

- (NSData *)responseData
{
  return self.buf;
}

@end
