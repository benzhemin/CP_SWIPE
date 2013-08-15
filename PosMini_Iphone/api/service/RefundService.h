//
//  RefundService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface RefundService : BasicService{
    int reqCount;
}


//请求退款接口
-(void)requestForRefundTrans;

//查询退款接口
-(void)queryForRefundState;

@end
