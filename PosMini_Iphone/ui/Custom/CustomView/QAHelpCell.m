//
//  CustomHelpCell.m
//  自定义TableViewCell,用于使用帮助TableView中
//
//  Created by songxiang
//  Copyright (c) 2013年 songxiang. All rights reserved.
//

#import "QAHelpCell.h"

@implementation QAHelpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //设置字体大小，颜色
        titleColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        titleFont = [UIFont boldSystemFontOfSize:14];
        contentColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        contentFont = [UIFont systemFontOfSize:14];
        
        //设置提问图标
        questionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q.png"]];
        questionImageView.frame = CGRectMake(10, 13, 16, 13);
        [self addSubview:questionImageView];
        [questionImageView release];
        
        //设置提问标题Label
        questionTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 5,self.frame.size.width-60, 10)];
        questionTitle.lineBreakMode = UILineBreakModeCharacterWrap;
        questionTitle.numberOfLines = 0;
        questionTitle.textColor = titleColor;
        questionTitle.font = titleFont;
        [self addSubview:questionTitle];
        [questionTitle release];
        
        //设置回答标题
        answerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A.png"]];
        answerImageView.frame = CGRectMake(10, 30, 14, 12);
        [self addSubview:answerImageView];
        [answerImageView release];
        
        //设置回答标题Label
        answerTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 5,self.frame.size.width-60, 10)];
        answerTitle.textColor = contentColor;
        answerTitle.numberOfLines = 0;
        answerTitle.lineBreakMode = UILineBreakModeCharacterWrap;
        answerTitle.font = contentFont;
        [self addSubview:answerTitle];
        [answerTitle release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


/**
	设置提问标题和回答内容
	@param question 提问标题
	@param answer 回答内容
 */
-(void) setQuestion:(NSString *)question setAnswer:(NSString *)answer
{
    float _begY = 10;
    //重设标题位置
    float titleHeight = [Helper getLabelHeight:question setfont:titleFont setwidth:questionTitle.frame.size.width];
    questionTitle.text = question;
    questionTitle.frame = CGRectMake(questionTitle.frame.origin.x, _begY, questionTitle.frame.size.width, titleHeight);
    _begY+=titleHeight;
    _begY+=8;
    //重设内容位置
    answerImageView.frame = CGRectMake(answerImageView.frame.origin.x, _begY, answerImageView.frame.size.width, answerImageView.frame.size.height);
    answerTitle.text = answer;
    float contentHeight = [Helper getLabelHeight:answer setfont:contentFont setwidth:answerTitle.frame.size.width];
    answerTitle.frame = CGRectMake(answerTitle.frame.origin.x, _begY-3, answerTitle.frame.size.width, contentHeight);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _begY+contentHeight+10);
}
@end
