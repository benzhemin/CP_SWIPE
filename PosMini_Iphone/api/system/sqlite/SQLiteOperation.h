//
//  SQLiteOperation.h
//  sqlite数据库操作类
//
//  Created by Atlas.song on 13-2-22.
//  Copyright 2012 ChinaPnr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface SQLiteOperation : NSObject {
    sqlite3 *database;
    NSString *path;
}

- (void)readyDatabase;
- (void)getPath;
- (NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col;
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param;

@end
