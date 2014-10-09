//
//  DOUMobileStatImp+ServiceAvailable.m
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/10/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUMobileStatImp+ServiceAvailable.h"
#import "DOUAppInfo.h"
#import "AmonsulConnection.h"
#import "DOUStatConstant.h"
#import "DOUMobileStatUtils.h"
#import "DOUStatConfig.h"
#import "DOUSharedUDID.h"

@implementation DOUMobileStatImp (ServiceAvailable)

- (void)sendRequestServiceAvailable
{
  NSString *apName = self.appname;
  if (apName == nil) {
    apName = [DOUAppInfo getAppDisplayName];
  }
  [self sendRequestServiceAvailableAppName:apName apiKey:self.apikey];
}

- (void)sendRequestServiceAvailableAppName:(NSString *)appName
                                    apiKey:(NSString *)key
{
  AmonsulConnection *connection = [[AmonsulConnection alloc] init];
  NSMutableString *params = [[NSMutableString alloc] init];
  [params appendString:kAmonSulCheck2RequestUrl];
  [params appendFormat:@"?app_name=%@&apikey=%@&sdkVersion=%@", appName, key, DOU_STAT_SDK_VERSION];
  [params appendFormat:@"&%@=%@", kJSON_KEY_DEVICEID, [DOUSharedUDID sharedUDID]];
  
  DTRACELOG(@"url : %@", params);
  [connection get:params
      queryParams:nil
            async:YES
          succeed:^(AmonsulConnection *conn) {
            [self handleCheck2Response:conn];
          } failure:NULL];
}

- (void)handleCheck2Response:(AmonsulConnection *)conn
{
  @try {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:conn.responseData
                                                        options:0
                                                          error:NULL];
    if ([dic[@"on"] integerValue] == 0) {
      DTRACELOG(@"service is unavailable");
      [self saveServiceAvailable:NO intervalSeconds:0];
    } else {
      NSInteger seconds = [dic[@"time_limit"] integerValue];
      [self saveServiceAvailable:YES intervalSeconds:seconds];
    }
  } @catch (NSException *exception) {
    DERRORLOG(@"ex : %@", exception);
    NSAssert(NO, @"exception happends");
  }
}

/*
 * 获取configupdate 的值。如果为空 默认为YES 如果为 0 返回 NO 为 1 返回 YES
 */
- (BOOL)isServiceAvailable
{
  BOOL ret = YES;
  DOUStatConfig *config = [DOUStatConfig localConfig];
  if (config) {
    ret = config.serviceAvailable;
  }
  return ret;
}

@end
