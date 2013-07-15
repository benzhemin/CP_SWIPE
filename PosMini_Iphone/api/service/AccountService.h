//
//  AccountService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"
#import "PosMiniCPRequest.h"


@interface AccountService : BasicService{
    
}

-(void)requestForUserInfo;

-(void)userInfoRequestDidFinished:(ASIHTTPRequest *)req;

@end
