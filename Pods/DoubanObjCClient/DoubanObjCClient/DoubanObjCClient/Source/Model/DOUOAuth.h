//
//  DOUOAuthStore.h
//  DOUAPIEngine
//
//  Created by Lin GUO on 11-10-31.
//  Copyright (c) 2011年 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

@interface DOUOAuth : DOUObject

@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSString *refreshToken;
@property (nonatomic, readonly) NSString *doubanUserID;
@property (nonatomic, readonly) NSString *doubanUserName;
@property (nonatomic, readonly) NSInteger expiresIn;

@end
