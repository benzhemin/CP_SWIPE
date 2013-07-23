//
//  CPRequest.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "NSNotificationCenter+CP.h"

@implementation NSNotificationCenter (CP)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject
{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
	[self postNotificationOnMainThread:notification];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[self postNotificationOnMainThread:notification];
}

-(void)postAutoSysPromptNotification:(NSString *)message{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message, NOTIFICATION_MESSAGE, nil];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_SYS_AUTO_PROMPT object:nil userInfo:dict];
}

-(void)postAutoUIPromptNotification:(NSString *)message{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message, NOTIFICATION_MESSAGE, nil];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_UI_AUTO_PROMPT object:nil userInfo:dict];
}

@end

