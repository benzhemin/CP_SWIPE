//
//  RegTextField.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegTextField : UIView{
    //标题
    UILabel *titleLabel;
    //输入框
    UITextField *inputTextField;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextField *inputTextField;

//设置标题
-(void)setTitle:(NSString *)_title;
//设置输入框默认文字
-(void)setPlaceholder:(NSString *)_placeHolder;
//设置键盘样式
-(void) setKeyBoardType:(UIKeyboardType)keyType;
//设置委托
-(void) setDelegate:(id<UITextFieldDelegate>)delegate;
//设置Tag
-(void) setFieldTag:(NSInteger)tag;
//设置键盘返回键
-(void) setReturnKeyType:(UIReturnKeyType)returnKeyType;
//让输入框获取焦点
-(void) setBecomeFirstResponder;
//获取输入内容
-(NSString *)getInputText;
//设置输入内容
-(void) setInputText:(NSString *)inputString;
//是否以密码形式显示
-(void) setSecureTextEntry:(Boolean)secureTextEntry;

@end
