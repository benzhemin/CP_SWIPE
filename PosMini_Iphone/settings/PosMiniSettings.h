//
//  PosMiniSettings.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosMiniSettings : NSObject{
@private
    NSMutableDictionary *mSettingsDict;
    BOOL isAbsolutePath;
}

@property (nonatomic, assign) BOOL isAbsolutePath;

+(PosMiniSettings*) instance;
+(void)destroyInstance;

-(NSString*)getSetting:(NSString*) key;
-(void) setDefaultTag:(NSString*)tag value:(NSString*)value;

@end
