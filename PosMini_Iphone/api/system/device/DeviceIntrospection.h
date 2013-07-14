//
//  DeviceIntrospection.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

NSString *platform();
NSString * platformString();

@interface DeviceIntrospection : NSObject

+(DeviceIntrospection *)sharedInstance;
+(void)destroySharedInstance;

-(NSString *)uuid;
-(NSString *)platformName;

@end