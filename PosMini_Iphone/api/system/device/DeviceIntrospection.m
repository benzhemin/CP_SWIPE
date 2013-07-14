//
//  DeviceIntrospection.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DeviceIntrospection.h"
#include <sys/types.h>
#include <sys/sysctl.h>

static DeviceIntrospection *sInstance = nil;

@implementation DeviceIntrospection

-(void)dealloc
{
    [super dealloc];
}

+(DeviceIntrospection *)sharedInstance
{
    if (sInstance == nil)
    {
        sInstance = [[DeviceIntrospection alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

#define DEVICE_IDENTIFIER @"DEVICEUDID"
#define DEVICE_PLATFORM @"DEVICEPLATFORM"

-(NSString *)uuid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *deviceUUID = [defaults stringForKey:DEVICE_IDENTIFIER];
    
    if (deviceUUID==nil) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
        CFRelease(puuid);
        CFRelease(uuidString);
        
        [defaults setObject:result forKey:DEVICE_IDENTIFIER];
        [defaults synchronize];
        
        return [result autorelease];
    }else{
        return deviceUUID;
    }
}

-(NSString *)platformName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *devPlatform = [defaults stringForKey:DEVICE_PLATFORM];
    if (devPlatform == nil) {
        NSString *pf = platformString();
        
        [defaults setObject:pf forKey:DEVICE_PLATFORM];
        [defaults synchronize];
        
        return pf;
    }else{
        return devPlatform;
    }
}

@end

/**
 获取系统中原始设备信息
 @returns 返回设备原始信息
 */
NSString *platform(){
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}


/**
 获取具体设备名称
 @returns 设备名称
 */
NSString * platformString(){
    NSString *pf = platform();
    if ([pf isEqualToString:@"iPod1,1"])    return @"iPod%20Touch";
    if ([pf isEqualToString:@"iPod2,1"])    return @"iPod%20Touch%20Second%20Generation";
    if ([pf isEqualToString:@"iPod3,1"])    return @"iPod%20Touch%20Third%20Generation";
    if ([pf isEqualToString:@"iPod4,1"])    return @"iPod%20Touch%20Fourth%20Generation";
    if ([pf isEqualToString:@"iPod5,1"])    return @"iPod%20Touch%20Fifth%20Generation";
    
    if ([pf isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([pf isEqualToString:@"iPhone1,2"])    return @"iPhone%203G";
    if ([pf isEqualToString:@"iPhone2,1"])    return @"iPhone%203GS";
    if ([pf isEqualToString:@"iPhone3,1"])    return @"iPhone%204";
    if ([pf isEqualToString:@"iPhone4,1"])    return @"iPhone%204S";
    if ([pf isEqualToString:@"iPhone5,1"])    return @"iPhone%205";
    
    if ([pf isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([pf isEqualToString:@"iPad2,1"])    return @"iPad%202";
    if ([pf isEqualToString:@"iPad3,1"])    return @"3rd%20Generation%20iPad";
    if ([pf isEqualToString:@"iPad3,4"])    return @"4th%20Generation%20iPad";
    if ([pf isEqualToString:@"iPad2,5"])    return @"iPad%20Mini";
    //if ([pf isEqualToString:@"i386"])    return @"simulator";
    return @"simulator";
}
