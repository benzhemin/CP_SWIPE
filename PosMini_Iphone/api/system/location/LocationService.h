//
//  LocationService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationService : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordination;
}

@property (assign, nonatomic) CLLocationCoordinate2D coordination;


+(LocationService *)sharedInstance;
+(void)destroySharedInstance;

-(BOOL)isCoordinationEmpty;

//whether the locationService did start
-(BOOL) startToLocateWithAuthentication:(BOOL)needAuthentication;

@end
