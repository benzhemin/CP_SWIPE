//
//  LocationService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LocationService.h"
#import "NSNotificationCenter+CP.h"

static LocationService *sInstance = nil;

@interface LocationService()

-(void)startToLocatePosMini;

@end

@implementation LocationService

@synthesize coordination;

-(void)dealloc
{
    [locationManager stopUpdatingLocation];
	locationManager.delegate = nil;
	CPSafeRelease(locationManager);
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        bzero(&coordination, sizeof(coordination));
    }
    return self;
}

+(LocationService *) sharedInstance
{
    if (sInstance == nil)
    {
        sInstance = [LocationService new];
    }
    return sInstance;
}

+(void) destroySharedInstance
{
    CPSafeRelease(sInstance);
}

-(BOOL) startToLocateWithAuthentication:(BOOL)needAuthentication
{
    if (needAuthentication && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                               [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted))
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认支付要使用您的位置,请到设置中打开定位服务" message:@"" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return NO;
    }else{
        [self startToLocatePosMini];
        return YES;
    }
}

-(void)startToLocatePosMini
{
    //登录成功进行GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        if (locationManager == nil)
        {
            locationManager = [[CLLocationManager alloc] init];
        }
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.distanceFilter = 1000;
        [locationManager stopUpdatingLocation];
        
        //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"定位中...", NOTIFICATION_MESSAGE, nil];
        //[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_UI_AUTO_PROMPT object:nil userInfo:dict];
        [locationManager startUpdatingLocation];
    }
}

#pragma mark LocationDelegate Method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    self.coordination = location.coordinate;
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [locationManager stopUpdatingLocation];
    //NSLog(@"Error: %@", error);
}

-(BOOL)isCoordinationEmpty
{
    if (coordination.latitude!=0.0f && coordination.longitude!=0.0f)
    {
        return NO;
    }else{
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //do nothing here
}

@end




















