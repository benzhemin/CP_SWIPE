//
//  CPRequest.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_TIME_OUT_SECONDS 20.0
#define DEFAULT_NUMBER_TO_RETRY_ON_TIME_OUT 2

@class CPRequest, ASIHTTPRequest;

@protocol CPResponseText <NSObject>
-(void)onResponseText:(NSString *)body withResponseCode:(unsigned int)responseCode;
@end

@protocol CPResponseData <NSObject>
-(void)onResponseData:(NSData *)body withResponseCode:(unsigned int)responseCode;
@end

@protocol CPResponseJSON <NSObject>
-(void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode;
@end

@protocol ExtendedRequest
-(void)setCPRequest:(CPRequest *)_request;
@end

@interface CPRequest : NSObject{
    //三个代理类
    id<CPResponseText> mResponseText;
    id<CPResponseData> mResponseData;
    id<CPResponseJSON> mResponseJSON;
    
    ASIHTTPRequest *mRequest;
    
    NSString *mResponseAsString;
    NSObject *mResponseAsJSON;
    NSData *mResponseAsData;
    
    NSString *mPath;
}

@property (nonatomic, retain, readonly) ASIHTTPRequest *request;

@property (nonatomic, retain) NSString *responseAsString;
@property (nonatomic, retain) NSObject *responseAsJson;
@property (nonatomic, retain) NSData *responseAsData;

//basic request
+(id)requestWithPath:(NSString *)path andASIClass:(Class)asiHttpRequestSubclass;

//specific request.
+(id)getRequestWithPath:(NSString *)path;

+(id)getRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query;
+(id)getRequestWithPath:(NSString *)path andQueryString:(NSString *)queryString;

+(id)putRequestWithPath:(NSString *)path andBody:(NSDictionary *)body;
+(id)putRequestWithPath:(NSString *)path andBodyString:(NSString *)bodyString;

+(id)postRequestWithPath:(NSString *)path andBody:(NSDictionary *)body;
+(id)postRequestWithPath:(NSString *)path andBodyString:(NSString *)bodyString;
+(id)postRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query;

+(id)deleteRequestWithPath:(NSString *)path;
+(id)deleteRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query;

//generic request
+(id)requestWithPath:(NSString *)path andMethod:(NSString *)method andArgs:(NSDictionary *)args;
+(id)requestWithPath:(NSString *)path andMethod:(NSString *)method andArgString:(NSString *)args;

//delegate call
- (id)onRespondText:(id<CPResponseText>)responseBlock;
- (id)onRespondData:(id<CPResponseData>)responseBlock;
- (id)onRespondJSON:(id<CPResponseJSON>)responseBlock;

-(void)execute;

-(void)cancel;

@end






























