//
//  SwipeCardViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

#define READ_CARD_TIMEOUT 120

typedef enum _SwipeCardType{
    PAY_SWIPE_TYPE = 1,
    REFOUND_SWIPE_TYPE
} SwipeCardType;

@interface SwipeCardViewController : BaseViewController{
    SwipeCardType scType;
    
    //显示银行卡图片
    UIImageView *bankCardView;
    
    //显示剩余时间
    UILabel *remainTime;
    
    NSTimer *timer;
    int timeCount;
    BOOL isTimerValid;
}

@property (nonatomic, assign) SwipeCardType scType;

@property (nonatomic, retain) UIImageView *bankCardView;
@property (nonatomic, retain) UILabel *remainTime;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) BOOL isTimerValid;

-(void)playAnimation;
-(void)invalidAnimation;
-(void)invalidateTimer;

@end
