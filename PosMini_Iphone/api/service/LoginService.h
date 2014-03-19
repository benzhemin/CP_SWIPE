//
//  LoginService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"
#import "PosMiniCPRequest.h"

@interface LoginService : BasicService{
    PosMiniCPRequest *loginReq;
}

-(void)loginRequest:(NSString *)acct withSecret:(NSString *)secret;
-(void)loginRequestDidFinished:(PosMiniCPRequest *)req;

@end
