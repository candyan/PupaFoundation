//
//  DOUMobileStat+Networking.h
//  AMousulIOS
//
//  Created by wise on 12-12-25.
//  Copyright (c) 2012年 Douban. All rights reserved.
//

#import "DOUMobileStatImp.h"
#import "DOUStatEvent.h"

extern const NSTimeInterval lastUploadMinInterval;

@interface DOUMobileStatImp (Event)

- (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation;
- (void)event:(NSString *)eventId
        label:(NSString *)label
          acc:(NSInteger)accumulation
       isSync:(BOOL)isSync;

- (void)beginEvent:(NSString *)eventId label:(NSString *)label;
- (void)endEvent:(NSString *)eventId label:(NSString *)label;

- (void)uploadAllEvents;
- (void)uploadAllEventsIfNeeded;

- (void)clearOldNormalEventsIfNeeded;
- (void)clearOldImportantEventsIfNeeded;

- (NSMutableDictionary *)event2Dictionary:(DOUStatEvent *)event;
- (NSMutableDictionary *)events2Dictionary:(NSArray *)events;

@end
