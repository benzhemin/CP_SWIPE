//
//  DataPickerViewController.h
//  PosMini_Iphone
//
//  Created by ben on 13-8-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


//选择数据类型
typedef enum {
    ProvinceType,
    AreaType,
}PickerDataType;

@protocol DataPickerDelegate <NSObject>
/**
 选中数据返回
 @param selectString 选择返回数据
 */
-(void) setSelectedString:(NSString *)selectString;
@end

@interface DataPickerViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    //数据选择类型
    PickerDataType dataType;
    //展示数据Table
    UITableView *dataTable;
    id<DataPickerDelegate> delegate;
    //数据源
    NSMutableArray *dataSource;
    NSString *keyWord;
}

@property (nonatomic, retain) UITableView *dataTable;
@property(nonatomic,assign) id<DataPickerDelegate> delegate;
@property(nonatomic)PickerDataType dataType;
@property(nonatomic,retain)  NSString *keyWord;

@end
