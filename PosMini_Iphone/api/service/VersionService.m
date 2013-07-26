//
//  VersionService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "VersionService.h"
#import "PosMiniSettings.h"
#import "PosMini.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation VersionService

-(void)checkForUpdate
{
    [[PosMini sharedInstance] showUIPromptMessage:@"检查版本更新" animated:YES];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *url = [NSString stringWithFormat:@"http://www.ttyfund.com/api/services/checkupdate_posmini.php?key=TTYFUND-CHINAPNR&app_client=posmini_app&app_platform=ios&app_version=%@",version];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [req setDidFinishSelector:@selector(versionRequestDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}

-(void)versionRequestDidFinished:(ASIHTTPRequest *)req
{
    
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = [[req responseString] JSONValue];
    
    if (NotNilAndEqualsTo(body, MTP_TTY_RESPONSE_CODE, @"1"))
    {
        if (NotNilAndEqualsTo(body, @"is_need_update", @"1"))
        {
            if (NotNilAndEqualsTo(body, @"force_update", @"1"))
            {
                //需要强制升级
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有一个新版本可以更新了!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertView.tag = 1;
                [alertView show];
                [alertView release];
            }
            else{
                //建议升级
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有一个新版本可以更新了!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.tag = 2;
                [alertView show];
                [alertView release];
            }
        }
        else
        {
            if ([target respondsToSelector:selector])
            {
                [target performSelector:selector];
            }
        }
    }
}

//ASIHTTPRequest failure callback
- (void) requestFailed:(ASIHTTPRequest *)request{
    [super requestFailed:request];
    
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"版本更新请求异常"];
    
    if ([target respondsToSelector:selector])
    {
        [target performSelector:selector];
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        //强制升级,这里如果在AppStore上架，需要App的Id号
    }else{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector];
        }
    }
}

@end
