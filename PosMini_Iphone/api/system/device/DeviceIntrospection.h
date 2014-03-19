//
//  DeviceIntrospection.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

NSString* getHardwareVersion();
NSString *platform();
NSString * platformString();
NSString * platformConvertString();

@interface DeviceIntrospection : NSObject

+(DeviceIntrospection *)sharedInstance;
+(void)destroySharedInstance;

-(NSString *)uuid;
-(NSString *)platformName;

//achieve ip address
-(NSString *)IPAddress;

@end