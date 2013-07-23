//
//  BasicService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PosMini.h"
#import "Helper.h"
#import "PosMiniCPRequest.h"
#import "CPRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSNotificationCenter+CP.h"

@interface BasicService : NSObject{
    id target;
    SEL selector;
}

- (id)onRespondTarget:(id)_target;
- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

@end
