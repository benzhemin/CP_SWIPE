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

@end
