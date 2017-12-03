//
//  CRTHTTPRequestManager.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class BFTask;

@interface CRTHTTPRequestManager : AFHTTPSessionManager

+ (instancetype)sharedReaderManager;
+ (instancetype)sharedArticleManager;

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters;
- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters;

@end
