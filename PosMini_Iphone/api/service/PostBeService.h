//
//  PostBeService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicService.h"
#import "ASIHTTPRequest.h"

@class PosMiniCPRequest;

@interface PostBeService : BasicService{
    
}

-(void)postBeRequest;
-(void)postBeForUID;

-(void)postBeDidFinished:(ASIHTTPRequest *)req;
-(void)UIDRequestDidFinished:(ASIHTTPRequest *)req;
@end
