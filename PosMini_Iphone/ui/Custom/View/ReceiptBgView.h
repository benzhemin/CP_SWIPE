//
//  ReceiptBgView.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptBgView : UIView{
    //虚线的高度
    float dashLineHeight;
    //实线的高度
    float fullLineHeight;
}

@property (nonatomic, assign) float dashLineHeight;
@property (nonatomic, assign) float fullLineHeight;

-(id) initWithDashHeight:(float)dashHeight fullHeight:(float)fullHeight;

@end
