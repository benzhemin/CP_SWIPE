//
//  CPRequest.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CPRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "NSNotificationCenter+CP.h"
#import "PosMiniSettings.h"

@interface CPRequest()

@property (nonatomic, retain) ASIHTTPRequest* request;
@property (nonatomic, retain) id<CPResponseText> responseText;
@property (nonatomic, retain) id<CPResponseData> responseData;
@property (nonatomic, retain) id<CPResponseJSON> responseJSON;



@property (nonatomic, retain) NSString *path;

-(void)requestFinishedOnRequestThread;
@end

@interface ExtendedGetRequest : ASIHTTPRequest <ExtendedRequest>
{
    CPRequest *cpRequest;
}
@end

@implementation ExtendedGetRequest
-(void)setCPRequest:(CPRequest *)_request
{
    [cpRequest release];
    cpRequest = [_request retain];
}

-(void)requestFinished
{
    [cpRequest requestFinishedOnRequestThread];
    [super requestFinished];
}
@end

@interface ExtendedFormRequest : ASIFormDataRequest <ExtendedRequest>
{
    CPRequest *cpRequest;
}
@end

@implementation ExtendedFormRequest

-(void)setCPRequest:(CPRequest *)_request
{
    [cpRequest release];
    cpRequest = [_request retain];
}

- (void)requestFinished
{
    [cpRequest requestFinishedOnRequestThread];
    [super requestFinished];
}
@end

static NSString *uriEncode(NSString *str)
{
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8) autorelease];
}

@protocol ArgBuilder
-(void)addArgument:(id)arg forKey:(NSString *)key;
@end

static void buildDict(id<ArgBuilder> builder, NSDictionary *body, NSString *prefix);

static void buildArr(id<ArgBuilder> builder, NSArray *arr, NSString *key)
{
    NSString *fullKey = [NSString stringWithFormat:@"%@[]", key];
    for (id o in arr)
    {
        if ([o isKindOfClass:[NSDictionary class]])
        {
            buildDict(builder, (NSDictionary *)o, fullKey);
        }
        else if ([o isKindOfClass:[NSArray class]])
        {
            buildArr(builder, (NSArray *)o, fullKey);
        }
        else
        {
            [builder addArgument:o forKey:fullKey];
        }
    }
}

static void buildDict(id<ArgBuilder> builder, NSDictionary *body, NSString *prefix)
{
    for (NSString *k in [body allKeys])
    {
        id v = [body objectForKey:k];
        NSString *fullKey = prefix ? [NSString stringWithFormat:@"%@[%@]", prefix, k] : k;
        if ([v isKindOfClass:[NSDictionary class]])
        {
            buildDict(builder, (NSDictionary *)v, fullKey);
        }
        else if([v isKindOfClass:[NSArray class]])
        {
            buildArr(builder, (NSArray *)v, fullKey);
        }
        else
        {
            [builder addArgument:v forKey:fullKey];
        }
    }
}

static void buildRoot(id<ArgBuilder> builder, NSDictionary *body)
{
    buildDict(builder, body, NULL);
}

@interface FormBuilder : NSObject<ArgBuilder>{
    ASIFormDataRequest *request;
}
@property (nonatomic, retain) ASIFormDataRequest* request;

- (void)addArgument:(id)arg forKey:(NSString*)key;
+ (FormBuilder*)builderForRequest:(ASIFormDataRequest*)request;
@end

@implementation FormBuilder
@synthesize request;

- (void)addArgument:(id)arg forKey:(NSString*)key{
    [self.request addPostValue:arg forKey:key];
}

+ (FormBuilder*)builderForRequest:(ASIFormDataRequest*)request{
    FormBuilder *rv = [[self new] autorelease];
    rv.request = request;
    return rv;
}

- (void)dealloc{
    self.request = nil;
    [super dealloc];
}

@end

@interface QueryBuilder : NSObject<ArgBuilder>
{
    NSMutableString *accum;
};
-(void)addArgument:(id)arg forKey:(NSString *)key;
-(NSString *)queryString;
@end

@implementation QueryBuilder

-(void)addArgument:(id)arg forKey:(NSString *)key
{
    if (accum) {
        [accum appendFormat:@"&%@=%@", uriEncode(key), uriEncode(arg)];
    }
    else
    {
        accum = [NSMutableString stringWithFormat:@"%@=%@", uriEncode(key), uriEncode(arg)];
    }
}

-(NSString *)queryString
{
    return accum;
}

@end

@implementation CPRequest

@synthesize responseText = mResponseText;
@synthesize  responseData = mResponseData;
@synthesize responseJSON = mResponseJSON;

@synthesize responseAsString = mResponseAsString;
@synthesize responseAsJson = mResponseAsJSON;
@synthesize responseAsData = mResponseAsData;

@synthesize path = mPath;

-(void)setRequest:(ASIHTTPRequest *)request
{
    //clean up existing
    mRequest.delegate = nil;
    [(ASIHTTPRequest<ExtendedRequest> *)mRequest setCPRequest:nil];
    [mRequest release];
    
    //setup new
    mRequest = [request retain];
    request.delegate = self;
    [(ASIHTTPRequest<ExtendedRequest>*)mRequest setCPRequest:self];
}

-(ASIHTTPRequest *)request
{
    return mRequest;
}

#pragma mark -
#pragma mark Life-Cycle
#pragma mark -

-(id)init
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

-(void)dealloc
{
    self.responseText = nil;
    self.responseJSON = nil;
    self.responseData = nil;
    
    self.responseAsString = nil;
    self.responseAsJson = nil;
    self.responseAsData = nil;
    
    self.path = nil;
    self.request = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Creation Methods
#pragma mark -

-(void)genRequestWithURL:(NSURL *)url andASIClass:(Class)asiHttpRequestSubclass
{
    ASIHTTPRequest* req = [[asiHttpRequestSubclass alloc] initWithURL:url];
    
    //config
    req.timeOutSeconds = DEFAULT_TIME_OUT_SECONDS;
    req.numberOfTimesToRetryOnTimeout = DEFAULT_NUMBER_TO_RETRY_ON_TIME_OUT;
    
    [req setValidatesSecureCertificate:NO];
    
    self.request = req;
    [req release];
}

- (void)genRequestWithPath:(NSString*)path andASIClass:(Class)asiHttpRequestSubclass
{
    static NSString* sServerURL = nil;
    if(!sServerURL){
        sServerURL = [[[[NSURL URLWithString:[[PosMiniSettings instance] getSetting:@"server-url"]] standardizedURL] absoluteString] retain];
    }
    
	if ([path hasPrefix:@"/"]){
		path = [path substringFromIndex:1];
	}
    
	[self genRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", sServerURL, path]] andASIClass:(Class)asiHttpRequestSubclass];
}

+(NSString *)embedQueryInPath:(NSString *)path andQuery:(NSDictionary *)query
{
    QueryBuilder *queryBuilder = [QueryBuilder new];
    buildRoot(queryBuilder, query);
    NSString *queryString = [queryBuilder queryString];
    [queryBuilder release];
    
    if (queryString) {
        path = [NSString stringWithFormat:@"%@?%@", path, queryString];
    }
    return path;
}

+(id)request{
    return [[[self alloc] init] autorelease];
}

+(id)requestWithPath:(NSString *)_path andASIClass:(Class)asiHttpRequestSubclass
{
    CPRequest *req = [self request];
    req.path = _path;
    [req genRequestWithPath:_path andASIClass:asiHttpRequestSubclass];
    return req;
}

+(id)getRequestWithPath:(NSString *)path
{
    return [self requestWithPath:path andASIClass:[ExtendedGetRequest class]];
}

+(id)getRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query
{
    return [self getRequestWithPath:[self embedQueryInPath:path andQuery:query]];
}

+(id)getRequestWithPath:(NSString *)path andQueryString:(NSString *)queryString{
    return [self getRequestWithPath:[NSString stringWithFormat:@"%@?%@", path, queryString]];
}

+(id)putRequestWithPath:(NSString *)path andBody:(NSDictionary *)body{
    CPRequest *req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"PUT";
    buildRoot([FormBuilder builderForRequest:(ASIFormDataRequest *)req->mRequest], body);
    return req;
}

+(id)putRequestWithPath:(NSString *)path andBodyString:(NSString *)bodyString{
    CPRequest *req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"PUT";
    
    [req.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    req.request.postBody = [NSMutableData dataWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	return req;
}

+(id)postRequestWithPath:(NSString *)path andBody:(NSDictionary *)body
{
    CPRequest *req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"POST";
    buildRoot([FormBuilder builderForRequest:(ASIFormDataRequest *)req->mRequest], body);
    return req;
}

+(id)postRequestWithPath:(NSString *)path andBodyString:(NSString *)bodyString{
    CPRequest *req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"POST";
    
    [req.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    req.request.postBody = [NSMutableData dataWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	return req;
}

+(id)postRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query{
    QueryBuilder *queryBuilder = [QueryBuilder new];
    buildRoot(queryBuilder, query);
    NSString *queryString = [queryBuilder queryString];
    [queryBuilder release];
    return [self postRequestWithPath:path andBodyString:queryString];
}

+(id)deleteRequestWithPath:(NSString *)path
{
    CPRequest *req = [self requestWithPath:path andASIClass:[ExtendedGetRequest class]];
    req.request.requestMethod = @"DELETE";
    return req;
}

+(id)deleteRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query{
    return [self deleteRequestWithPath:[self embedQueryInPath:path andQuery:query]];
}

+(id)requestWithPath:(NSString *)path andMethod:(NSString *)method andArgs:(NSDictionary *)args
{
    if ([method isEqualToString:@"GET"])
		return [self getRequestWithPath:path andQuery:args];
	
	if ([method isEqualToString:@"POST"])
		return [self postRequestWithPath:path andBody:args];
	
	if ([method isEqualToString:@"PUT"])
		return [self putRequestWithPath:path andBody:args];
	
	if ([method isEqualToString:@"DELETE"])
		return [self deleteRequestWithPath:path];
	
	return nil;
}

+(id)requestWithPath:(NSString *)path andMethod:(NSString *)method andArgString:(NSString *)args
{
    if ([method isEqualToString:@"GET"])
		return [self getRequestWithPath:path andQueryString:args];
	
	if ([method isEqualToString:@"POST"])
		return [self postRequestWithPath:path andBodyString:args];
	
	if ([method isEqualToString:@"PUT"])
		return [self putRequestWithPath:path andBodyString:args];
	
	if ([method isEqualToString:@"DELETE"])
		return [self deleteRequestWithPath:path];
	
	return nil;
}

#pragma mark -
#pragma mark Response Delegate Methods
#pragma mark -

- (id)onRespondText:(id<CPResponseText>)responseBlock
{
	self.responseText = responseBlock;
	return self;
}

- (id)onRespondData:(id<CPResponseData>)responseBlock;
{
	self.responseData = responseBlock;
	return self;
}

- (id)onRespondJSON:(id<CPResponseJSON>)responseBlock;
{
	self.responseJSON = responseBlock;
	return self;
}

- (void)execute
{
    [mRequest startAsynchronous];
}

- (void)cancel
{
    if (mRequest) {
        [mRequest clearDelegatesAndCancel];
    }
}

- (void)retry
{
	self.request = [mRequest copy];
    [self execute];
}

- (void)requestFinishedOnRequestThread
{
	if (mResponseText || mResponseJSON)
	{
		NSStringEncoding encoding = [mRequest responseEncoding];
		if (!encoding) encoding = NSUTF8StringEncoding;
		NSData* d = [mRequest responseData];
		mResponseAsString = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:encoding];
	}
	
	if (mResponseJSON)
	{
		self.responseAsJson = [mResponseAsString JSONValue];
	}
	
	if (mResponseData)
	{
		self.responseAsData = [mRequest responseData];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (mRequest.responseStatusCode >= 200 && mRequest.responseStatusCode < 300)
    {
        [mResponseText onResponseText:mResponseAsString withResponseCode:mRequest.responseStatusCode];
        [mResponseData onResponseData:mResponseAsData withResponseCode:mRequest.responseStatusCode];
        [mResponseJSON onResponseJSON:mResponseAsJSON withResponseCode:mRequest.responseStatusCode];
    }else if (mRequest.responseStatusCode == 404){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUIRE_USER_LOGIN object:nil];
        
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"长时间未使用，请重新登录!"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"服务器返回异常"];
    }
	
	// we're done here
	self.request = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    
    NSError *error = [request error];
    NSString *description = [error localizedDescription];
    NSLog(@"%@", description);
    
    NSLog(@"网络异常　url:%@", request.url);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
    
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"网络连接失败"];
}

@end






