//
//  DOUUser.m
//  DoubanApiClient
//
//  Created by Lin GUO on 4/25/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUUser.h"

@implementation DOUUser

@dynamic identifier;
@dynamic avatar;
@dynamic avatarURL;
@dynamic largeAvatar;
@dynamic largeAvatarURL;
@dynamic alt;
@dynamic name;
@dynamic uid;
@dynamic desc;
@dynamic locId;
@dynamic locName;
@dynamic signature;
@dynamic isSuicides;
@dynamic vaildAvatar;
@dynamic vaildAvatarURL;

- (NSString *)identifier
{
  return [self.dictionary objectForKey:@"id"];
}

- (NSString *)avatar
{
  return [self.dictionary objectForKey:@"avatar"];
}

- (NSURL *)avatarURL
{
  return [NSURL URLWithString:self.avatar];
}

- (NSString *)largeAvatar
{
  return [self.dictionary objectForKey:@"large_avatar"];
}

- (NSURL *)largeAvatarURL
{
  return [NSURL URLWithString:self.largeAvatar];
}

- (NSString *)alt
{
  return [self.dictionary objectForKey:@"alt"];
}


- (NSString *)name
{
  return [self.dictionary objectForKey:@"name"];
}


- (NSString *)uid
{
  return [self.dictionary objectForKey:@"uid"];
}


- (NSString *)desc
{
  return [self.dictionary objectForKey:@"desc"];
}

- (NSString *)locId
{
  return [self.dictionary objectForKey:@"loc_id"];
}


- (NSString *)locName
{
  return [self.dictionary objectForKey:@"loc_name"];
}

-(NSString *)signature
{
  return [self.dictionary objectForKey:@"signature"];
}

- (BOOL)isSuicides
{
  return [[self.dictionary objectForKey:@"is_suicide"] boolValue];
}

- (NSString *)vaildAvatar
{
  if (self.largeAvatar) {
    return self.largeAvatar;
  } else {
    return self.avatar;
  }
}

- (NSURL *)vaildAvatarURL
{
  return [NSURL URLWithString:self.vaildAvatar];
}

- (BOOL)isEqual:(id)object
{
  if (self == object) return YES;
  
  if ([object isKindOfClass:[self class]]) {
    return [[object identifier] isEqualToString:self.identifier];
  }
  return NO;
}

@end
