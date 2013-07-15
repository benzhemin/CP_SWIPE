//
//  PostBeService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PostBeService.h"
#import "DeviceIntrospection.h"
#import "CPRequest.h"
#import "PosMiniCPRequest.h"
#import "PosMiniSettings.h"
#import "PosMini.h"
#import "Helper.h"
#import "JSON.h"
#import "DeviceIntrospection.h"

@implementation PostBeService

-(void)postBeRequest{
    
    NSDateFormatter *_dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"];
    NSDate *date = [NSDate date];
    
    
    NSString *url = [NSString stringWithFormat:@"http://www.ttyfund.com/api/services/postbe.php?act=postbe&key=TTYFUND-CHINAPNR&app_client=minipos_client&app_platform=ios&app_version=%@&id=%@&uid=%@&model=%@&channel=&mail=&date=%@",
                                                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                                                [[DeviceIntrospection sharedInstance] uuid],
                                                [Helper getValueByKey:@"uid"],
                                                [[DeviceIntrospection sharedInstance] platformName],
                                                [_dateFormatter stringFromDate:date]];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [req setDidFinishSelector:@selector(postBeDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}
-(void)postBeDidFinished:(ASIHTTPRequest *)req{
    //NSLog(@"postBe req finished");
}

-(void)postBeForUID{
    NSString *host = @"http://www.ttyfund.com/api/services/postbe.php";
    NSString *param = [NSString stringWithFormat:@"act=get_uid&key=TTYFUND-CHINAPNR&mac_id=%@", [[DeviceIntrospection sharedInstance] uuid]];
    NSString *url = [NSString stringWithFormat:@"%@?%@", host, param];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [req setDidFinishSelector:@selector(UIDRequestDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}

-(void)UIDRequestDidFinished:(ASIHTTPRequest *)req{
    
    id body = [req.responseString JSONValue];

    if (NotNilAndEqualsTo(body, MTP_TTY_RESPONSE_CODE, @"1")) {
        [Helper saveValue:[body valueForKey:POSTBE_UID] forKey:POSTBE_UID];
    }
}

@end
