//
//  PosMiniCPRequest.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CPRequest.h"

BOOL NotNil(id dict, NSString *k);
BOOL NotNilAndEqualsTo(id dict, NSString *k, NSString *value);

@interface PosMiniCPRequest : CPRequest <CPResponseJSON, CPResponseText>{
    id target;
    SEL selector;
    
    //请求类型
    int reqtype;
    
    //record request info
    NSMutableDictionary *userInfo;
    
    NSString *respDesc;
}

@property (nonatomic, assign) int reqtype;
@property (nonatomic, retain) NSMutableDictionary *userInfo;

@property (nonatomic, copy) NSString *respDesc;

- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

@end
