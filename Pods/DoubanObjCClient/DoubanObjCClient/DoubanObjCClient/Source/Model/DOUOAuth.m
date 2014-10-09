//
//  DOUOAuth2Consumer.m
//  DOUAPIEngine
//
//  Created by Lin GUO on 11-10-31.
//  Copyright (c) 2011年 Douban Inc. All rights reserved.
//

#import "DOUOAuth.h"

@implementation DOUOAuth

@dynamic accessToken;
@dynamic refreshToken;
@dynamic doubanUserID;
@dynamic doubanUserName;
@dynamic expiresIn;

-(NSString *)accessToken {
  return [self.dictionary objectForKey:@"access_token"];
}

-(NSInteger)expiresIn {
  return [[self.dictionary objectForKey:@"expires_in"] integerValue];
}

-(NSString *)refreshToken {
  return [self.dictionary objectForKey:@"refresh_token"];
}

-(NSString *)doubanUserID {
  return [self.dictionary objectForKey:@"douban_user_id"];
}

-(NSString *)doubanUserName {
  return [self.dictionary objectForKey:@"douban_user_name"];
}

@end
