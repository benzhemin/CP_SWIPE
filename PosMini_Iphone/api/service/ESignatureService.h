//
//  ESignatureService.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface ESignatureService : BasicService
/**
 *  发送电子签购单请求
 *
 *  @param dict 请求参数
 */

-(void)requestForSendESignature:(NSMutableDictionary *)dict;
@end
