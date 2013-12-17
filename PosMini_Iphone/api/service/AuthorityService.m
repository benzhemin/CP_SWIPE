//
//  AuthorityService.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AuthorityService.h"

@implementation AuthorityService

-(void)requestForAuthority:(NSMutableDictionary *)dict{
    [[PosMini sharedInstance] showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/queryBusiOpenStatus"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(authorityRequestDidFinished:)];
    [posReq execute];
}

-(void)authorityRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    NSLog(@"AuthorityService:%@", body);
    
    self.businessOpenStatusDict=[[[NSDictionary alloc]init]autorelease];
    
    if (NotNil(body, @"RecvBusi")) {
        [_businessOpenStatusDict setValue:[body valueForKey:@"RecvBusi"] forKey:@"RecvBusi"];
    }
    if (NotNil(body, @"PersonalBusi")) {
        [_businessOpenStatusDict setValue:[body valueForKey:@"PersonalBusi"] forKey:@"PersonalBusi"];
    }

    if (target && [target respondsToSelector:@selector(authorityRequestDidFinished)]) {
        [target performSelector:@selector(authorityRequestDidFinished)];
    }
}

-(void)dealloc{
    [_businessOpenStatusDict release];
    [super dealloc];
}
@end
