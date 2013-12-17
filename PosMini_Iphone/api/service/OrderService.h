//
//  OrderService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface OrderService : BasicService

-(void)requestForOrderRecord:(NSDictionary *)param;

/*Add_S 启明 费凯峰 功能点:增加阶段查询*/
-(void)requestForOrderRecordStatistics:(NSDictionary *)param;
/*Add_E 启明 费凯峰 功能点:增加阶段查询*/
@end
