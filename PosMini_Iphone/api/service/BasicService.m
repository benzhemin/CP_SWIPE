//
//  BasicService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

BOOL NotNil(NSDictionary *dict, NSString *k){
    if ([dict objectForKey:k] != nil) {
        return YES;
    }
    return NO;
}

BOOL NotNilAndEqualsTo(NSDictionary *dict, NSString *k, NSString *value){
    if ([dict valueForKey:k]!=nil && [[NSString stringWithFormat:@"%@", [dict valueForKey:k]] isEqualToString:value]) {
        return YES;
    }
    return NO;
}

@implementation BasicService

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

@end
