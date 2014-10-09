//
//  DOUUser.h
//  DoubanApiClient
//
//  Created by Lin GUO on 4/25/12.
//  readonlyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

@interface DOUUser : DOUObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *avatar;
@property (nonatomic, readonly) NSURL *avatarURL;
@property (nonatomic, readonly) NSString *largeAvatar;
@property (nonatomic, readonly) NSURL *largeAvatarURL;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *alt;
@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSString *signature;
@property (nonatomic, readonly) BOOL isSuicides;

@property (nonatomic, readonly) NSString *locId;
@property (nonatomic, readonly) NSString *locName;

@property (nonatomic, readonly) NSString *vaildAvatar;
@property (nonatomic, readonly) NSURL *vaildAvatarURL;

@end