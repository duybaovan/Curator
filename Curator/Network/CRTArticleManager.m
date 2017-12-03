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
#import "RLMRealm+Curator.h"

#import "CRTArticle.h"

@implementation CRTArticleManager

+ (instancetype)sharedArticleManager {
    static dispatch_once_t onceToken;
    static CRTArticleManager *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CRTArticleManager alloc]init];
    });
    return _sharedInstance;
}

//- (BFTask *)getArticleWithURL : (NSURL *)url {
//    NSDictionary *params = @{@"url" : url};
//    return [[[CRTHTTPRequestManager sharedReaderManager]GET:@"parser" parameters:params]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
//        NSDictionary *result = t.result;
//        //change to updating our object reference.
//        return [BFTask taskWithResult:result[@"content"]];
//    }];
//}

- (BFTask *)downloadArticles {
    return [[[CRTHTTPRequestManager sharedArticleManager]GET:@"articles" parameters:nil]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSArray *results = t.result[@"result"];
        __block NSMutableArray<NSString *> *articleIDs = [NSMutableArray array];
        RLMRealm *realm = [RLMRealm defaultRealm];
        return [[realm crt_TransactionWithBlock:^{
            for (NSDictionary *articleDictionary in results) {
                CRTArticle *article = [CRTArticle articleFromDictionary:articleDictionary];
                [articleIDs addObject:article.serverID] ;
                [realm addOrUpdateObject:article];
            }
        }]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
            RLMResults *objectsToDelete = [CRTArticle objectsWhere:@"NOT (serverID IN %@)", articleIDs];
            return [realm crt_TransactionWithBlock:^{
                [realm deleteObjects:objectsToDelete];
            }];
        }];

    }];
}

- (BFTask *)markArticleWithID : (NSString *)serverID asReal : (BOOL)isReal {
    NSDictionary *params = @{@"isReal" : [NSNumber numberWithBool:isReal],
                             @"id" : serverID
                             };
    
    
    return [[[CRTHTTPRequestManager sharedArticleManager]POST:@"rate" parameters:params]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        return [realm crt_TransactionWithBlock:^{
            CRTArticle *article = [CRTArticle articleFromDictionary:t.result];
            [realm addOrUpdateObject:article];
        }];
    }];
}

- (RLMResults *)articles {
    return [[CRTArticle allObjects]sortedResultsUsingKeyPath:@"publishedDate" ascending:NO];
}




@end
