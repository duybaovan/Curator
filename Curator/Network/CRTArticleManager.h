//
//  CRTArticleManager.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask, RLMResults;

@interface CRTArticleManager : NSObject

+ (instancetype)sharedArticleManager;
- (BFTask *)getArticleWithURL : (NSURL *)url;
- (BFTask *)markArticleWithID : (NSString *)serverID asReal : (BOOL)isReal;
- (RLMResults *)articles;
- (BFTask *)downloadArticles;

@end
