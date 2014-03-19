//
//  CustomHelpCell.h
//  自定义TableViewCell,用于使用帮助TableView中
//
//  Created by songxiang
//  Copyright (c) 2013年 songxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface QAHelpCell : UITableViewCell
{
    UIImageView *questionImageView;//显示提问图标
    UIImageView *answerImageView;//显示回答图标
    UILabel *questionTitle;//显示提问问题
    UILabel *answerTitle;//显示回答
    
    UIFont *titleFont;//标题字体
    UIFont *contentFont;//内容字体
    UIColor *titleColor;//标题字体颜色
    UIColor *contentColor;//内容字体颜色
}
//设置提问标题和回答内容
-(void) setQuestion:(NSString *)question setAnswer:(NSString *)answer;
@end
