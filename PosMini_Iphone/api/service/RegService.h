//
//  RegService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

typedef enum{
    REQ_SMS = 1,
    REQ_REG,
} REG_REQ_TYPE;

@interface RegService : BasicService

-(void)requestForSendSMS:(NSMutableDictionary *)dict;

-(void)requestForRegisterUsr:(NSMutableDictionary *)dict;

@end
