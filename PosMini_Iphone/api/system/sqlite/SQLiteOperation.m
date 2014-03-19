//
//  SQLiteOperation.m
//  sqlite数据库操作类
//
//  Created by Atlas.song on 13-2-22.
//  Copyright 2012 ChinaPnr.com. All rights reserved.
//

#import "SQLiteOperation.h"

@implementation SQLiteOperation
#pragma mark 准备数据库
- (void)readyDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"prov_area.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    [self getPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"prov_area.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

#pragma mark 路径
- (void)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"prov_area.sqlite"];
}

#pragma mark 查询数据库
/************
 sql：sql语句
 col：sql语句需要操作的表的所有字段数
 ***********/
- (NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col {
    [self readyDatabase];
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];//所有记录
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableArray *row = [[NSMutableArray alloc] init];//一条记录
                //NSLog(@"=====%@",statement);
                for(int i=0; i<col; i++){
					const char *tempString = (char *)sqlite3_column_text(statement, i);
                    NSString *plaintext;
                    if (tempString==nil) {
                       plaintext=@""; 
                    }
                    else {
                       plaintext=[[[NSString alloc] initWithCString:tempString encoding:NSUTF8StringEncoding] autorelease]; 
                    }
					[row addObject:plaintext];
                }
                [returnArray addObject:row];
                [row release];
            }//end while
        }else {
            sqlite3_close(database);
            return NO;
        }//end if
        sqlite3_finalize(statement);
    } 
    else 
    {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }//end if
    sqlite3_close(database);
    return returnArray;
}

#pragma mark 增，删，改数据库
/************
 sql：sql语句
 param：sql语句中?对应的值组成的数组
 ***********/
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param {
    [self readyDatabase];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to prepare");
            sqlite3_close(database);
            return NO;
        }
        //绑定参数
        NSInteger max = [param count];
        for (int i=0; i<max; i++) {
            NSString *temp = [param objectAtIndex:i];
            sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
        }
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            sqlite3_close(database);
            NSLog(@"Error: failed to insert into the database");
            return NO;
        }
    }
    sqlite3_close(database);
    NSLog(@"dealData 成功");
    return TRUE;
}

- (void)dealloc{
    [super dealloc];
}
@end
