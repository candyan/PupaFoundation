//
//  NSString+DFURLEscape.h
//  DOUFoundation
//
//  Created by Candyan on 4/8/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PAURLEscape)

- (NSString *)encodingStringUsingURLEscape;

- (NSString *)decodingStringUsingURLEscape;

@end
