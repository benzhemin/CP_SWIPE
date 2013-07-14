//
//  VersionService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicService.h"
#import "ASIHTTPRequest.h"

@interface VersionService : BasicService <UIAlertViewDelegate>{
    
}

-(void)checkForUpdate;

-(void)versionRequestDidFinished:(ASIHTTPRequest *)req;

@end
