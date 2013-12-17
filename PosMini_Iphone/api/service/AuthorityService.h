//
//  AuthorityService.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface AuthorityService : BasicService
/**
 *  业务开通情况
 */
@property(nonatomic,retain)NSDictionary *businessOpenStatusDict;
/**
 *  请求便民业务权限
 *
 *  @param dict 请求参数
 */
-(void)requestForAuthority:(NSMutableDictionary *)dict;

@end
