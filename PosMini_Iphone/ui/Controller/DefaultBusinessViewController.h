//
//  DefaultBusinessViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "AuthorityService.h"

@interface DefaultBusinessViewController : BaseViewController
{
    //查询便民业务权限
    AuthorityService *authorityService;
}

@property(nonatomic,retain)NSDictionary *businessOpenStatusDict;
/**
 *  logo图片
 */
@property (nonatomic,retain)UIImageView *logoImage;
/**
 *  商户简称
 */
@property (nonatomic,retain)UILabel *businessNameLabel;
/**
 *  手机充值按钮
 */
@property (nonatomic,retain)UIButton *phoneButton;
/**
 *  手机充值
 */
@property (nonatomic,retain)UILabel *phoneLabel;
/**
 *  电影票按钮
 */
@property (nonatomic,retain)UIButton *movieButton;
/**
 *  电影票
 */
@property (nonatomic,retain)UILabel *movieLabel;
/**
 *  交通违章按钮
 */
@property (nonatomic,retain)UIButton *trafficButton;
/**
 *  交通违章
 */
@property (nonatomic,retain)UILabel *trafficLabel;
/**
 *  我要收款按钮
 */
@property (nonatomic,retain)UIButton *moneyButton;
/**
 *  我要收款
 */
@property (nonatomic,retain)UILabel *moneyLabel;

@end
