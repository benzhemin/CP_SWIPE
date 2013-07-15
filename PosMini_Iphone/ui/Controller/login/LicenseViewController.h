//
//  LicenseViewController.h
//  许可协议页面
//
//  Created by songxiang
//  Copyright (c) 2012年 songxiang. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTextView.h"
//#import "RegisterViewController.h"

@interface LicenseViewController : BaseViewController<UIScrollViewDelegate>
{
    Boolean isReadAll;//是否看过所有的许可协议
}
/**
 处理注册按钮点击
 @param sender 系统参数
 */
-(void) registerClick:(id)sender;
@end
