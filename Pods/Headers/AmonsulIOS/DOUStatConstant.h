//
//  StatConstant.h
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef amonDemo_StatConstant_h
#define amonDemo_StatConstant_h

#ifdef DEBUG_TRACELOG
#define DTRACELOG(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define DTRACELOG(xx, ...)
#endif

#ifdef DEBUG_INFOLOG
#define DINFOLOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define DINFOLOG(xx, ...)
#endif

#define DWARNLOG(xx, ...)  NSLog(@"[WARNING] %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define DERRORLOG(xx, ...) NSLog(@"[ERROR] %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)


#define DOU_STAT_SDK_VERSION                 @"1.6.1"

#define kAppNetworkWifi                      @"wifi"
#define kAppNetwork3G                        @"3G"
#define kAppNetworkUnKnown                   @"unknown"
#define kDevicePlatform                      @"iOS"
#define kAppDefaultChannel                   @"AppStore"

#define kStatEventFirstLaunch                @"appFirstLaunch"
#define kStatEventLaunch                     @"appLaunch"
#define kStatEventLaunchLabelEnterForeground @"foreground"
#define kStatEventLaunchLabelBecomeActive    @"active"
#define kStatEventTerminal                   @"appTerminal"
#define kStatEventLaunchLabelEnterBackground @"background"
#define kStatEventLaunchLabelBecomeInActive  @"inactive"

#define kStatEventFileDelete                 @"event_file_deleted"

#define kStatEventBeginEvent                 @"beginEvent"
#define kStatEventEndEvent                   @"endEvent"

//#define kStatLastTerminalKey @"lastterminal"
//#define kStatLastTerminalPlist @"lastterminal.plist"


#define kJSON_KEY_APPINFO                    @"ai" //@"app_info"
#define kJSON_KEY_EVENTINFO                  @"et" //@"event"
#define kJSON_KEY_EVENTSINFO                 @"ets" //@"events"
#define kJSON_KEY_DEVICEINFO                 @"di" //@"device_info"

#define kJSON_KEY_LANGUAGE                   @"lu" //@"language"
#define kJSON_KEY_COUNTRY                    @"cn" //@"country"
#define kJSON_KEY_VERSIONCODE                @"vc" //@"version_code"
#define kJSON_KEY_LAT                        @"lat"
#define kJSON_KEY_LNG                        @"lng" //@"lng"
#define kJSON_KEY_NET                        @"net" //@"net"
#define kJSON_KEY_CHANNEL                    @"ch" //@"channel"
#define kJSON_KEY_USERID                     @"ui" //@"userid"
#define kJSON_KEY_TIMEZONE                   @"tz" //@"timezone"
#define kJSON_KEY_SDKVERSION                 @"sv" //@"sdk_version"

#define kJSON_KEY_OS                         @"os"
#define kJSON_KEY_OSVERSION                  @"osv" //@"os_version"
#define kJSON_KEY_CARRIER                    @"cr" //@"carrier"
#define kJSON_KEY_DEVICE                     @"dv" //@"device"
#define kJSON_KEY_RESOLUTION                 @"rt" //@"resolution"
#define kJSON_KEY_DEVICEID                   @"did" //@"device_id"
#define kJSON_KEY_UDID_FOR_APP               @"app_did" //@"app udid"
#define kJSON_KEY_IDENTIFY_FOR_VENDOR        @"ifv" // @identifierForVendor

#define kJSON_KEY_EVENTTIME                  @"tm" //@"time"
#define kJSON_KEY_EVENTPAGE                  @"pg" //@"page"
#define kJSON_KEY_EVENT                      @"evt" //@"event"
#define kJSON_KEY_EVENTCOUNT                 @"cnt" //@"count"
#define kJSON_KEY_EVENTACTION                @"ac" //@"action"
#define kJSON_KEY_EVENTNAME                  @"nm" //@name
#define kJSON_KEY_EVENTLABEL                 @"lb" //@"label"
#define kJSON_KEY_EVENTVERSION               @"vn" //@"version"

#define kJSON_KEY_APPNAME                    @"apn" //@"app_name"
#define kJSON_KEY_PACKAGE                    @"pcg" //@"package"

#define KJSON_KEY_LOGS                       @"logs"

#define kAmonSulHostname                     @"amonsul.douban.com"
#define kAmonSulBaseHostUrl                  @"http://"kAmonSulHostname
#define kAmonSulCheckRequestUrl              kAmonSulBaseHostUrl@ "/check"
#define kAmonSulCheck2RequestUrl              kAmonSulBaseHostUrl@ "/check2"

#endif
