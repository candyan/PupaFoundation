//
//  DOUDebugUtilities.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 21/05/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUDebugUtilities.h"

double kDOUAbsoluteTimeConversion = 0.0;

static
__attribute__((constructor))
void ___initialize_kDOUAbsoluteTimeConversion(void)
{
  kern_return_t kret;
  mach_timebase_info_data_t info;

  kret = mach_timebase_info(&info);
  assert(kret == KERN_SUCCESS);

  kDOUAbsoluteTimeConversion = 1.0e-9 * info.numer / info.denom;
}
