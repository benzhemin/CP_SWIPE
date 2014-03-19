//
//  SettingBankViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DataPickerViewController.h"
#import "BindCardService.h"


@interface SettingBankViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, DataPickerDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    //显示数据Table
    UITableView *showDataTable;
    int selectIndex;
    NSMutableArray *dataSource;
    //设置默认收款银行账号
    NSString *defaultBankAccountString;
    //输入银行卡号
    UITextField *bankAccount;
    
    BindCardService *bindService;
}

@property(nonatomic,retain) NSString *defaultBankAccountString;

//处理按钮事件
-(void)btnClick:(id)sender;

/**
 通过省份名称查询Id
 @param provName 省份名称
 @returns 省份Id
 */
-(NSString *)getProvIdByName:(NSString *)provName;

/**
 通过地区名称查询Id
 @param areaName 地区名称
 @returns 省份Id
 */
-(NSString *)getAreaIdByName:(NSString *)areaName;

@end
