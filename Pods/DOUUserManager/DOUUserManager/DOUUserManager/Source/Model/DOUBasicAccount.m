//
//  DOUBasicAccount.m
//  DOUUserManager
//
//  Created by Jianjun Wu on 3/26/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUBasicAccount.h"

@interface DOUBasicAccount ()
@property (nonatomic, copy, readwrite) NSString * userUUID; // 用户的UUID
@end

@implementation DOUBasicAccount

- (id)init {
  self = [super init];
  @throw [NSException exceptionWithName:@"DOUBasicAccountInitNotAvailable"
                                 reason:@"init is not available."
                               userInfo:nil];
  return nil;
}

- (id)initWithUserUUID:(NSString *)userUUID {
  self = [super init];
  
  if (userUUID == nil || userUUID.length < 1) {
    @throw [NSException exceptionWithName:@"DOUBasicAccountInitParamInvaild"
                                   reason:@"DOUBasicAccount must have userUUID"
                                 userInfo:nil];
    return nil;
  }
  
  if (self) {
    self.userUUID = userUUID;
  }
  return self;
}

- (BOOL)isValidAccount {
  
  return self.userUUID != nil && self.userUUID.length > 0;
}

- (BOOL)isEqual:(id)object {
  
  if ([object isKindOfClass:[self class]] == NO) {
    return NO;
  }
  
  id<DOUBasicAccount> that = (id<DOUBasicAccount>)object;
  if (self.userUUID == nil) {
    return NO;
  }
  if (that.userUUID == nil) {
    return NO;
  }
  return [self.userUUID isEqualToString:that.userUUID];
}

- (NSString *)description {

  return [NSString stringWithFormat:@"uuid: %@", self.userUUID];
}

@end


@implementation DOUCommonAccount


@end

NSString * const kDOUSharedAccountUserInfoKeyAppID        = @"app_id";
NSString * const kDOUSharedAccountUserInfoKeyAppName      = @"app_name";
NSString * const kDOUSharedAccountUserInfoKeyAppURLScheme = @"app_url_scheme";
