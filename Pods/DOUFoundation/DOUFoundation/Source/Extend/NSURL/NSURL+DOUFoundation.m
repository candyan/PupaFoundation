//
//  NSURL+DOUFoundation.m
//  DOUFoundation
//
//  Created by Tony Li on 8/29/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSURL+DOUFoundation.h"
#import "NSString+DFURLEscape.h"
#import "NSMutableDictionary+MultipleItems.h"

@implementation NSURL (DOUFoundation)

- (NSDictionary *)queryDictionary {
  NSString *query = [self query];
  if ([query length] == 0) {
    return nil;
  }
  
  // Replace '+' with space
  query = [query stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
  
  NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
  NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
  
  NSScanner *scanner = [[NSScanner alloc] initWithString:query];
  while (![scanner isAtEnd]) {
    NSString *pairString = nil;
    [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
    [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
    NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
    if (kvPair.count == 2) {
      [pairs addItem:[[kvPair objectAtIndex:1] decodingStringUsingURLEscape]
              forKey:[[kvPair objectAtIndex:0] decodingStringUsingURLEscape]];
    }
  }
  
  return [pairs copy];
}

@end
