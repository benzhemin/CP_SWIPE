//
//  RegTextField.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RegTextField.h"
#import "Helper.h"

#define MARGIN_LEFT 10

@implementation RegTextField

@synthesize titleLabel, inputTextField;

-(void)dealloc{
    [titleLabel release];
    [inputTextField release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景圆角图片
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgImageView.image = [[UIImage imageNamed:@"radius.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self addSubview:bgImageView];
        [bgImageView release];
        
        //初始化标题
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        UIFont *titleFont = [UIFont systemFontOfSize:18];
        titleLabel.font = titleFont;
        titleLabel.backgroundColor = [UIColor clearColor];
        UIColor *titleColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1.0];
        titleLabel.textColor = titleColor;
        [self addSubview:titleLabel];
        
        //初始化输入框
        self.inputTextField = [[[UITextField alloc] init] autorelease];
        inputTextField.frame = CGRectMake(MARGIN_LEFT, 0, frame.size.width-2*MARGIN_LEFT, frame.size.height);
        inputTextField.borderStyle = UITextBorderStyleNone;
        inputTextField.font = [UIFont systemFontOfSize:16];
        inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:inputTextField];
    }
    return self;
}

//设置标题
-(void)setTitle:(NSString *)title
{
    titleLabel.text = title;
    float titleWidth = [Helper getLabelWidth:title setFont:titleLabel.font setHeight:self.frame.size.height];
    titleLabel.frame = CGRectMake(MARGIN_LEFT, 0, titleWidth, self.frame.size.height);
    
    inputTextField.frame = CGRectMake(titleWidth+MARGIN_LEFT+2, 0, self.frame.size.width-titleWidth-2*MARGIN_LEFT-2, self.frame.size.height);
    
}
//设置输入框默认文字
-(void)setPlaceholder:(NSString *)_placeHolder
{
    [inputTextField setPlaceholder:_placeHolder];
}

//设置键盘样式
-(void) setKeyBoardType:(UIKeyboardType)keyType
{
    inputTextField.keyboardType = keyType;
}

//设置委托
-(void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    inputTextField.delegate = delegate;
}
//设置Tag
-(void) setFieldTag:(NSInteger)tag
{
    self.tag = tag;
    inputTextField.tag = tag;
}
//设置键盘返回键
-(void) setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    inputTextField.returnKeyType = returnKeyType;
}
//让输入框获取焦点
-(void) setBecomeFirstResponder
{
    [inputTextField becomeFirstResponder];
}

//获取输入内容
-(NSString *)getInputText
{
    return inputTextField.text;
}

//设置输入内容
-(void) setInputText:(NSString *)inputString
{
    [inputTextField setText:inputString];
}

//是否以密码形式显示
-(void) setSecureTextEntry:(Boolean)secureTextEntry
{
    inputTextField.secureTextEntry = secureTextEntry;
}

@end
