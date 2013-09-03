//
//  CPNavigationController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPNavigationDelgate;

@interface CPNavigationController : UINavigationController {
    CPNavigationDelgate *cpNaviDelegate;
}

@end
