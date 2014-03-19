//
//  PosMiniSettings.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMiniSettings.h"

@interface PosMiniSettings()
@property (nonatomic, retain) NSMutableDictionary* settingsDict;
@end


static PosMiniSettings* sInstance = nil;

@implementation PosMiniSettings

@synthesize settingsDict = mSettingsDict;
@synthesize isAbsolutePath;

-(void)dealloc{
    self.settingsDict = nil;
    [super dealloc];
}

+(PosMiniSettings*) instance {
    if(sInstance == nil)
    {
        sInstance = [PosMiniSettings new];
    }
    return sInstance;
}

+(void)destroyInstance{
    CPSafeRelease(sInstance);
}

-(id)init{
    if((self = [super init])){
        self.settingsDict = [NSMutableDictionary dictionaryWithCapacity:20];
        
		[self setDefaultTag:@"server-url" value:HOST_URL];
        
        isAbsolutePath = NO;
    }
    return self;
}

-(NSString*)getSetting:(NSString*) key{
    return [self.settingsDict objectForKey:key];
}

-(void) setDefaultTag:(NSString*)tag value:(NSString*)value{
    [self.settingsDict setObject:value forKey:tag];
}

@end
