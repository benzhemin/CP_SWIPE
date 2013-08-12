//
//  SignView.m
//  Landscape
//
//  Created by ben on 13-7-21.
//  Copyright (c) 2013年 ben. All rights reserved.
//

#import "SignView.h"

@implementation SignView

@synthesize pointsList;

-(void)dealloc{
    [pointsList release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
        self.pointsList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    beginDraw = YES;
    UITouch *touch = [touches anyObject];
    CGPoint beginPoint = [touch locationInView:self];
    [pointsList addObject:[NSValue valueWithCGPoint:beginPoint]];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (beginDraw) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        [pointsList addObject:[NSValue valueWithCGPoint:point]];
        [self setNeedsDisplay];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    beginDraw = NO;
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self];
    [pointsList addObject:[NSValue valueWithCGPoint:endPoint]];
    [pointsList addObject:@"#"];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor);
    if (pointsList.count == 0) {
        [@"请在此输入你的电子签名" drawInRect:CGRectMake(0, (rect.size.height-40)/2, rect.size.width, 40) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    }
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 4);
    CGContextBeginPath(context);
    
    int index = 0;
    for (int i=0; i<pointsList.count; i++) {
        if ([[pointsList objectAtIndex:i] isKindOfClass:[NSString class]] && [[pointsList objectAtIndex:i] isEqualToString:@"#"]) {
            index = 0;
            CGContextStrokePath(context);
        }
        else
        {
            CGPoint tempPoint = [[pointsList objectAtIndex:i]CGPointValue];
            if (index == 0) {
                index++;
                CGContextMoveToPoint(context, tempPoint.x, tempPoint.y);
            }
            else {
                CGContextAddLineToPoint(context, tempPoint.x, tempPoint.y);
            }
        }
    }
    CGContextStrokePath(context);
}

-(void)clear{
    [pointsList removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drawSignFromArray:(NSArray *)points{
    [self.pointsList removeAllObjects];
    
    //deep copy
    for (NSValue *val in points) {
        [pointsList addObject:[NSValue valueWithCGPoint:[val CGPointValue]]];
    }
    
    [self setNeedsDisplay];
}

@end













