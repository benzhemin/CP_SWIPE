//
//  CPTabBar.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBarDelegate.h"

@interface CPTabBar : UIView{
    //store tab
    NSMutableArray *tabViewList;
    
    //tab view
    NSMutableArray *tabIconList;
    NSMutableArray *tabIconHoverList;
    NSMutableArray *tabTitleList;
    
    id<CPTabBarDelegate> delegate;
    
    int index;
}

@property (nonatomic, retain) NSMutableArray *tabViewList;

@property (nonatomic, assign) id<CPTabBarDelegate> delegate;

//process tap event
-(void) tapGesture:(UITapGestureRecognizer *)tapGesuture;

-(void) setTabSelected:(int)tab_index;

@end
