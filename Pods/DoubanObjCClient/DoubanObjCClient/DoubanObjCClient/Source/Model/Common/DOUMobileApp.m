//
//  DOUMobileApp.m
//  DoubanObjCClient
//
//  Created by Candyan on 2/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUMobileApp.h"

@implementation DOUMobileApp

@dynamic appName;
@dynamic appDesc;
@dynamic appDoubanURL;
@dynamic appIconURL;
@dynamic appStoreURL;
@dynamic appVersion;
@dynamic appUpdated;

- (NSString *) appVersion {
  return [[self.dictionary objectForKey:@"version"] objectForKey:@"@value"];
}

- (NSString *) appStoreURL {
  return [[self.dictionary objectForKey:@"store_url"] objectForKey:@"@value"];
}

-(NSString *)appName {
  return [[self.dictionary objectForKey:@"name"] objectForKey:@"@value"];
}

-(NSString *)appDesc {
  return [[self.dictionary objectForKey:@"desc"] objectForKey:@"@value"];
}

-(NSString *)appIconURL {
  return [[[self.dictionary objectForKey:@"link"] objectAtIndex:1] objectForKey:@"@href"];
}

-(NSString *)appDoubanURL {
  return [[[self.dictionary objectForKey:@"link"] objectAtIndex:0] objectForKey:@"@href"];
}

-(NSString *)appUpdated {
  return [[self.dictionary objectForKey:@"updated"] objectForKey:@"@value"];
}

@end
