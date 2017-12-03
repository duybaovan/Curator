//
//  CRTArticleRouter.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRTArticle;

@protocol CRTArticleRouterDelegate

- (NSURL *)markArticleAsReal : (BOOL)isReal;
- (CRTArticle *)currentArticle;

@end

@interface CRTArticleRouter : NSObject <CRTArticleRouterDelegate>

- (NSURL *)markArticleAsReal : (BOOL)isReal;
- (NSInteger)numberOfArticles;
- (CRTArticle *)articleAtIndex : (NSInteger)index;
- (CRTArticle *)currentArticle;


@property (nonatomic) NSInteger selectedIndex;

@end
