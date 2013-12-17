//
//  UnbindService.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"


@interface UnbindService : BasicService

/**
 *  请求短信验证码
 *
 *  @param dict 请求参数
 */
-(void)requestForSendSMS:(NSMutableDictionary *)dict;
/**
 *  请求解绑
 *
 *  @param dict 请求参数
 */
-(void)requestForUnbind:(NSMutableDictionary *)dict;

@end
