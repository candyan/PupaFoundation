//
//  DOUMobileApp.h
//  DoubanObjCClient
//
//  Created by liu yan on 2/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

@interface DOUMobileApp : DOUObject

@property (nonatomic, readonly) NSString *appName;
@property (nonatomic, readonly) NSString *appStoreURL;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appIconURL;
@property (nonatomic, readonly) NSString *appDesc;
@property (nonatomic, readonly) NSString *appDoubanURL;
@property (nonatomic, readonly) NSString *appUpdated;

@end
