//
//  DOUMobileStatImp+Network.m
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/10/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUMobileStatImp+Network.h"
#import "DOUMobileStatEventStorage.h"
#import "DOUMobileStatImp+ServiceAvailable.h"
#import "DOUMobileStatImp+Event.h"
#import "DOUStatConstant.h"
#import "DOUAppInfo.h"
#import "NSString+DOUStat.h"
#import "NSDictionary+DOUJSON.h"
#import "NSArray+DOUJSON.h"
#import "DOUSharedUDID.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "DOUMobileStatUtils.h"

@implementation DOUMobileStatImp (Network)

- (void)syncSendEventRequest:(DOUStatEvent *)event
{
  if ([self isServiceAvailable] == NO
      || self.internetReachability.currentReachabilityStatus == DOUAmonsulNotReachable) {
    // 服务不可用，不发送事件，但是事件会保存
    [[DOUMobileStatEventStorage sharedInstance] asyncWritelEventToDisk:event];
  } else {
    NSMutableDictionary *dic = [self event2Dictionary:event];
    NSString *reqUrl = [self generateRequestUrl];
    NSMutableString *params1 = [[NSMutableString alloc] init];
    [params1 appendString:@"logs="];
    NSString *logs = [dic toJsonStringInDOUStat];
    [params1 appendString:logs];
    
    AmonsulConnection *connection = [[AmonsulConnection alloc] init];
    [connection post:reqUrl
                body:params1
               async:NO
             succeed:^(AmonsulConnection *conn) {
               DTRACELOG(@"Event did send : URL %@, logs posting : %@", reqUrl, logs);
             }
     
             failure:^(AmonsulConnection *conn) {
               DINFOLOG(@"Event did fail to send with URL %@, write to disk: %@", reqUrl, logs);
               [[DOUMobileStatEventStorage sharedInstance] asyncWritelEventToDisk:event];
             }];
    DTRACELOG(@"Url : %@, logs posting : %@", reqUrl, logs);
  }
}

- (void)sendEventsInFile:(NSString *)filePath
                 succeed:(void (^)())succeedBlock
                 failure:(void (^)())failureBlock
{
  if ([self isServiceAvailable] == NO
      || self.internetReachability.currentReachabilityStatus == DOUAmonsulNotReachable) {
    return;
  }
  
  BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
  if (isExisted == NO) {
    return;
  }
  
  NSArray *events = [NSArray arrayWithContentsOfFile:filePath];
  if (events == nil || [events count] < 1) {
    [[DOUMobileStatEventStorage sharedInstance] deleteEventLogFile:filePath];
    DERRORLOG(@"Empty events at path %@", filePath);
    if (failureBlock != NULL) {
      dispatch_async(dispatch_get_main_queue(), failureBlock);
    }
    return;
  }
  
  [[DOUMobileStatEventStorage sharedInstance] addSendingPath:filePath];
  AmonsulConnection *connection = [[AmonsulConnection alloc] init];
  NSMutableDictionary *dic = [self events2Dictionary:events];
  NSString *logs = [dic toJsonStringInDOUStat];
  NSString *reqUrl = kAmonSulBaseHostUrl;
  
  NSData *data = [logs dataUsingEncoding:NSUTF8StringEncoding];
  data = [data gzipDeflate];
  NSMutableURLRequest *request = [NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:reqUrl]
                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                  timeoutInterval:kAmonsuleNetworkTimeout];
  [self writePostBodyToRequest:request
                withBodyParams:[self requestParams]
                      gzipData:data];
  [connection sendRequeset:request
                     async:NO
                   succeed:^(AmonsulConnection *conn) {
                     [[DOUMobileStatEventStorage sharedInstance] deleteEventLogFile:filePath];
                     DTRACELOG(@"Sent events through url %@, with logs %@", reqUrl, logs);
#ifdef DEBUG
                     NSString *respStr = [[NSString alloc] initWithData:conn.responseData
                                                               encoding:NSUTF8StringEncoding];
                     NSAssert([respStr isEqualToString:@"OK"], @"amonsul request invalid response");
                     
#endif
                     if (succeedBlock != NULL) {
                       dispatch_async(dispatch_get_main_queue(), succeedBlock);
                     }
                   }
   
                   failure:^(AmonsulConnection *conn) {
                     [[DOUMobileStatEventStorage sharedInstance] removeSendingPath:filePath];
                     DERRORLOG(@"Failed to send events through url %@, with logs %@", reqUrl, logs);
                     if (failureBlock != NULL) {
                       dispatch_async(dispatch_get_main_queue(), failureBlock);
                     }
                   }];
}

- (void)sendEventRequest:(DOUStatEvent *)event
                 inQueue:(NSOperationQueue *)quque
{
  [quque addOperationWithBlock:^{
    [self syncSendEventRequest:event];
  }];
}

- (void)sendEventsInFile:(NSString *)filePath
                 inQueue:(NSOperationQueue *)quque
                 succeed:(void (^)())succeedBlock
                 failure:(void (^)())failureBlock
{
  if ([[DOUMobileStatEventStorage sharedInstance] isSendingEventLogFile:filePath]) {
    return;
  }
  [[DOUMobileStatEventStorage sharedInstance] addSendingPath:filePath];
  [quque addOperationWithBlock:^{
    [self sendEventsInFile:filePath succeed:succeedBlock failure:failureBlock];
  }];
}

#pragma mark - util
- (NSString *)generateRequestUrl
{
  NSMutableString *url = [[NSMutableString alloc] init];
  [url appendString:kAmonSulBaseHostUrl];
  
  NSDictionary *params = [self requestParams];
  NSMutableArray *parts = [NSMutableArray array];
  for (id key in params) {
    id value = [params objectForKey: key];
    NSString *part = [NSString stringWithFormat: @"%@=%@",
                      [DOUMobileStatUtils urlEscapeString:key],
                      [DOUMobileStatUtils urlEscapeString:value]];
    [parts addObject: part];
  }
  if (parts.count > 0) {
    [url appendFormat:@"?%@", [parts componentsJoinedByString: @"&"]];
  }
  return url;
}

- (NSDictionary *)requestParams
{
  NSString *apName = self.appname;
  if (apName == nil) {
    apName = [DOUAppInfo getAppDisplayName];
  }
  NSMutableDictionary *params = [@{ @"app_name": apName,
                                      @"apikey": self.apikey } mutableCopy];
  if (self.userUID != nil) {
    [params setObject:self.userUID forKey:@"userid"];
  }
  if (self.md5Token != nil && ![self.md5Token isEqualToString:@""]) {
    [params setObject:self.md5Token forKey:@"token"];
  }
  [params setObject:[DOUSharedUDID sharedUDID] forKey:kJSON_KEY_DEVICEID];
  
  [params setObject:[DOUMobileStatUtils localTimeStringForNow] forKey:@"ltime"];
  
#if DEBUG
  [params removeObjectForKey:@"ltime"];
#endif
  
  return params;
}

- (void)writePostBodyToRequest:(NSMutableURLRequest *)req
                withBodyParams:(NSDictionary *)bodyParams
                      gzipData:(NSData *)gzipData
                 dataParamName:(NSString *)paramName
                      filename:(NSString *)filename
{
  NSString *boundary = [NSString stringWithFormat:@"------%ld__%ld__%ld", random(), random(), random()];
  NSString *multipartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [req setHTTPMethod:@"POST"];
  [req setValue:multipartContentType forHTTPHeaderField:@"Content-type"];
  
  //adding the body:
  NSMutableData *postBody = [NSMutableData data];
  // Add params
  NSEnumerator *keyEnum = [bodyParams keyEnumerator];
  NSString *key = nil;
  while ((key = [keyEnum nextObject])) {
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *value = [NSString stringWithFormat:@"%@", [bodyParams objectForKey:key]];
    [postBody appendData:[value dataUsingEncoding : NSUTF8StringEncoding]];
  }
  
  // Add json data as file
  if (gzipData) {
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentDisposition = [NSString stringWithFormat:
                                    @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                    paramName, filename];
    [postBody appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:gzipData];
  }
  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  [req setHTTPBody:postBody];
}

- (void)writePostBodyToRequest:(NSMutableURLRequest *)req
                withBodyParams:(NSDictionary *)bodyParams
                      gzipData:(NSData *)gzipData
{
  [self writePostBodyToRequest:req
                withBodyParams:bodyParams
                      gzipData:gzipData
                 dataParamName:@"ziplogs"
                      filename:@"ziplog.txt.gz"];
}

@end
