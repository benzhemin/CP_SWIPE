//
//  SignLandscapeViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "SignView.h"

@interface SignLandscapeViewController : BaseViewController{
    SignView *signView;
    UIButton *confirmBtn;
    UIButton *clearBtn;
    UILabel *clearLabel;
    
    BOOL showHint;
    UILabel *hintMsgLabel;
}

@property (nonatomic, retain) SignView *signView;
@property (nonatomic, retain) UIButton *confirmBtn;
@property (nonatomic, retain) UIButton *clearBtn;
@property (nonatomic, retain) UILabel *clearLabel;

@property (nonatomic, assign) BOOL showHint;
@property (nonatomic, retain) UILabel *hintMsgLabel;

-(void)displayHintMessage;

@end
