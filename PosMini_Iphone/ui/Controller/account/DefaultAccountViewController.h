//
//  DefaultAccountViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountService.h"

@interface DefaultAccountViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    //显示账户信息
    UITableView *acctInfoTableView;
    
    AccountService *acctService;
    
    NSMutableDictionary *userInfoDict;
}

@property (nonatomic, retain) UITableView *acctInfoTableView;
@property (nonatomic, retain) AccountService *acctService;
@property (nonatomic, retain) NSMutableDictionary *userInfoDict;

-(void)accountRequestDidFinished;

/**
 设置取现账户
 @param bankCardNum 银行卡号
 */
-(void) setBankNumString:(NSString *)bankCardNum;

/*Add_S 启明 张翔 功能点:商户信息配置*/
/**
 设置商户简称
 @param merchantString 商户简称
 */
-(void) setMerchantString:(NSString *)merchantString;
/*Add_E 启明 张翔 功能点:商户信息配置*/

/*Add_S 启明 张翔 功能点:解除绑定*/
/**
 设置设备编号
 */
-(void) setBindedMtId;
/*Add_E 启明 张翔 功能点:解除绑定*/

-(void)refreshTableView;

@end
