//
//  CPNavigationController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CPNavigationController.h"
#import "PosMiniDevice.h"
#import "BaseViewController.h"

@interface CPNavigationDelgate : NSObject <UINavigationControllerDelegate>
@end

@implementation CPNavigationDelgate

//防止popViewController时,设置错误的controller
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BaseViewController *CTRL = (BaseViewController *) viewController;
    [PosMiniDevice sharedInstance].baseCTRL = CTRL;
}

@end

@interface CPNavigationController ()

@end

@implementation CPNavigationController

-(void)dealloc{
    [cpNaviDelegate release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        cpNaviDelegate = [CPNavigationDelgate new];
    }
    return self;
}

//support ios6 for landscape mode
- (NSUInteger)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

@end
