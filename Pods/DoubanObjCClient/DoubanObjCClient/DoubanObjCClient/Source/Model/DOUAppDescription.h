//
//  DOUAppDescription.h
//  DoubanObjCClient
//
//  Created by Candyan on 12/28/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUAppDescription : NSObject {
  NSString *_appKey;
  NSString *_appSecret;
  NSString *_appRedirectURL;
}

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appSecret;
@property (nonatomic, copy) NSString * appRedirectURL;

+ (DOUAppDescription *) currentAppDescription;

+ (void) setAppDescriptionWithAppKey:(NSString *)appkey
                           appSecret:(NSString *)appSecret
                      appRedirectURL:(NSString *)appRedirectURL;

@end
