//
//  AccountService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface AccountService : BasicService{
    NSMutableDictionary *userInfoDict;
}
@property (nonatomic, retain) NSMutableDictionary *userInfoDict;

-(void)requestForUserInfo;

-(void)userInfoRequestDidFinished:(PosMiniCPRequest *)req;

@end
