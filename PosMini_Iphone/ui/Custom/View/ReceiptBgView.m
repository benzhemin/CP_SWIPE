//
//  ReceiptBgView.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ReceiptBgView.h"

@implementation ReceiptBgView

@synthesize dashLineHeight, fullLineHeight;

-(id) init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(id) initWithDashHeight:(float)dashHeight fullHeight:(float)fullHeight{
    dashLineHeight = dashHeight;
    fullLineHeight = fullHeight;
    return [self init];
}

- (void)drawRect:(CGRect)rect
{
    //画分割线
    float lengths[] = {4,2};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, dashLineHeight);
    CGContextAddLineToPoint(context, rect.size.width, dashLineHeight);
    CGContextStrokePath(context);
    
    if (fullLineHeight != 0.0f) {
        CGContextSetLineWidth(context, 2.0);
        float linelengths[] = {5,0};
        CGContextSetLineDash(context, 0, linelengths, 0);
        UIColor *color1 =[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        // UIColor *color2=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
        float margin_left=15;
        CGContextSetStrokeColorWithColor(context, color1.CGColor);
        CGContextMoveToPoint(context, margin_left, fullLineHeight);
        CGContextAddLineToPoint(context, rect.size.width-margin_left, fullLineHeight);
        CGContextStrokePath(context);
    }
}


@end
