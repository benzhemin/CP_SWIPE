//
//  DefaultAccountViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface DefaultAccountViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    //显示账户信息
    UITableView *acctInfoTableView;
    
    NSMutableDictionary *userInfoDict;
    
    
}

@property (nonatomic, retain) UITableView *acctInfoTableView;

/**
 设置取现账户
 @param bankCardNum 银行卡号
 */
-(void) setBankNumString:(NSString *)bankCardNum;

-(void)refreshTableView;

@end
