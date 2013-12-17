//
//  ElectronicSignRequisitionsViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface ElectronicSignRequisitionsViewController : BaseViewController
/**
 *  电子签购单页面
 */
@property(nonatomic,retain)UIImageView *eSignImageView;
/**
 *  取消发送按钮 
 */
@property(nonatomic,retain)UIButton *cancelButton;
/**
 *  发送签购单按钮
 */
@property(nonatomic,retain)UIButton *sendButton;
@end
