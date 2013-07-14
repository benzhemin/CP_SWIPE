//
//  PosMiniCPRequest.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CPRequest.h"

@interface PosMiniCPRequest : CPRequest <CPResponseJSON, CPResponseText>{
    id target;
    SEL selector;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

@end
