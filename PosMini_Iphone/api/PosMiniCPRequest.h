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
    
    //record request info
    NSMutableDictionary *userInfo;
}

@property (nonatomic, retain) NSMutableDictionary *userInfo;

- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

@end
