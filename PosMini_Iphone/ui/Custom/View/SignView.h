//
//  SignView.h
//  Landscape
//
//  Created by ben on 13-7-21.
//  Copyright (c) 2013年 ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignView : UIView{
    //画笔是否触摸屏幕开始签名
    Boolean beginDraw;
    //触点存储信息
    NSMutableArray *pointsList;
}

@property (nonatomic, retain) NSMutableArray *pointsList;

-(void)clear;

-(void)drawSignFromArray:(NSArray *)points;

@end
