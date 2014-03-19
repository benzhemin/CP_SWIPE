//
//  ESignatureService.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ESignatureService.h"

@implementation ESignatureService

-(void)requestForSendESignature:(NSMutableDictionary *)dict{
    [[PosMini sharedInstance] showUIPromptMessage:@"发送中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/sendESalesSlip"];
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(eSignatureRequestDidFinished:)];
    [posReq execute];
}

-(void)eSignatureRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (target && [target respondsToSelector:@selector(eSignatureRequestDidFinished)]) {
        [target performSelector:@selector(eSignatureRequestDidFinished)];
    }
}
@end
