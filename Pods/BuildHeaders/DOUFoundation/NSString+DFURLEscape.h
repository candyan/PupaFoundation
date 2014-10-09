//
//  NSString+DFURLEscape.h
//  DOUFoundation
//
//  Created by liu yan on 4/8/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DFURLEscape)

- (NSString *)encodingStringUsingURLEscape;

- (NSString *)decodingStringUsingURLEscape;

@end
