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

BOOL NotNil(NSDictionary *dict, NSString *k);
BOOL NotNilAndEqualsTo(NSDictionary *dict, NSString *k, NSString *value);

@interface BasicService : NSObject{
    id target;
    SEL selector;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

@end
