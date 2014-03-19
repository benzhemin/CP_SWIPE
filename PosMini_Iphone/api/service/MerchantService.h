//
//  MerchantService.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface MerchantService : BasicService

@property(nonatomic,retain)NSDictionary *merchantInfoDict;
/**
 *  向服务器发送请求保存商户信息
 *
 *  @param dict 商户信息
 */
-(void)requestForSetMerchantInfo:(NSMutableDictionary *)dict;

/**
 *  向服务器发送请求获取商户信息
 */
-(void)requestForMerchantInfo;
@end
