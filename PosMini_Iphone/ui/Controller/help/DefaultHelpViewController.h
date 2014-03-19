//
//  DefaultHelpViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface DefaultHelpViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{
    //显示用户帮助信息
    UITableView *helpTableView;
}

@property (nonatomic, retain) UITableView *helpTableView;

@end
