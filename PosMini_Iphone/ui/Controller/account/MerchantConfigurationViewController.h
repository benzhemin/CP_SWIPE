//
//  MerchantConfigurationViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "DataPickerViewController.h"
#import "MerchantService.h"

@interface MerchantConfigurationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DataPickerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
    //数据列表
    NSMutableArray *dataSource;
    int selectIndex;
    //商户全称
    UITextField *merchantCompleteName;
    //商户简称
    UITextField *merchantShortName;
    //商户地址
    UITextField *merchantAddress;
    //商户电话 区号
    UITextField *merchantAreaCode;
    //商户电话 座机号
    UITextField *merchantTelephone;
    
    MerchantService *merchantService;
    
    BOOL isNeedMoveView;
    int editingTextFieldTag;
    CGRect originalViewRect;
    

}
@property(nonatomic,retain)UIScrollView *backScrollView;

@property(nonatomic,retain)UITableView *showDataTable;

@property(nonatomic,retain)NSDictionary *merchantInfoDic;

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
