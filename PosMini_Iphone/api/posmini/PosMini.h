//
//  PosMini.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "PosMiniCPRequest.h"

@interface PosMini : NSObject <MBProgressHUDDelegate>{
    MBProgressHUD *uiPromptHUD;
    MBProgressHUD *sysPromptHUD;
}

@property (nonatomic, retain) MBProgressHUD *uiPromptHUD;
@property (nonatomic, retain) MBProgressHUD *sysPromptHUD;

+(PosMini *)sharedInstance;
+(void)destroySharedInstance;
+(void)initializePosMini;
+(void)shutdown;

-(void) showUIPromptMessage:(NSString *)message animated:(BOOL)animated;
-(void)postHideUIPromptMessage;
-(void) hideUIPromptMessage:(BOOL)animated;
-(void) changeUIPromptMessage:(NSString *)message;

-(void) showSysPromptMessage:(NSString *)message animated:(BOOL)animated;
-(void) hideSysPromptMessage:(BOOL)animated;

-(void) displayUIPromptAutomatically:(NSNotification *)inNotification;
-(void) displaySysPromptAutomatically:(NSNotification *)inNotification;

-(void)performRequest:(ASIHTTPRequest *)req;

@end























