//
//  CRTArticleManager.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticleManager.h"

#import "CRTHTTPRequestManager.h"

#import <Bolts/Bolts.h>

@implementation CRTArticleManager

+ (instancetype)sharedArticleManager {
    static dispatch_once_t onceToken;
    static CRTArticleManager *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CRTArticleManager alloc]init];
    });
    return _sharedInstance;
}

- (BFTask *)getArticleWithURL : (NSURL *)url {
    NSDictionary *params = @{@"url" : url};
    return [[[CRTHTTPRequestManager sharedReaderManager]GET:@"parser" parameters:params]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSDictionary *result = t.result;
        //change to updating our object reference.
        return [BFTask taskWithResult:result[@"content"]];
    }];
}

@end
