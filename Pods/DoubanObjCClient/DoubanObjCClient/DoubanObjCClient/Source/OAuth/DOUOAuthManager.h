//
//  OAuthManager.h
//  DoubanObjCClient
//
//  Created by Candyan on 1/19/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DOUOAuth;

@interface DOUOAuthManager : NSObject

@property (nonatomic, retain) DOUOAuth *currentOAuth;

+(DOUOAuthManager *) sharedInstance;

/*
 This method get oauth array that need to migrate from client v0.1.x.
 */
- (NSArray *)oauthArrayForMigration;


/*
 This method remove all oauths that has been migrated.
 */
- (void)removeAllMigratedOAuths;

@end
