//
//  CRTHTTPRequestManager.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTHTTPRequestManager.h"

#import <Bolts/Bolts.h>

#import "CRTAPIKeys.h"

@implementation CRTHTTPRequestManager

+ (instancetype)sharedReaderManager {
    static dispatch_once_t onceToken;
    static CRTHTTPRequestManager *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CRTHTTPRequestManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://mercury.postlight.com/"]authorizationHeader:@"x-api-key" authorizationToken:kCRTMercuryAPIKey];
    });
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url authorizationHeader:nil authorizationToken:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           authorizationHeader : (NSString *)headerName
            authorizationToken : (NSString *) token {
    
    self = [super initWithBaseURL:url];
    if(self) {
        
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        if(headerName && token) {
            [serializer setValue:token forHTTPHeaderField:headerName];
        }
        
        
        [self setRequestSerializer:serializer];
    }
    return self;
}

- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //left blank
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [completionSource setResult:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [completionSource setError:error];
    }];
    

    return completionSource.task;
}

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //left blank
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [completionSource setResult:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [completionSource setError:error];
    }];
    return completionSource.task;

}

@end
