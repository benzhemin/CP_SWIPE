//
//  BindCardService.m
//  PosMini_Iphone
//
//  Created by ben on 13-8-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BindCardService.h"

@implementation BindCardService

-(void)requestForBindCard:(NSMutableDictionary *)dict{
    NSString* url = [NSString stringWithFormat:@"/mtp/action/management/autoCashCardSetting"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(bindRequestDidFinished:)];
    [posReq execute];
}

-(void)bindRequestDidFinished:(PosMiniCPRequest *)req{
    if (target && [target respondsToSelector:@selector(bindRequestDidFinished)]) {
        [target performSelector:@selector(bindRequestDidFinished)];
    }
}



@end
