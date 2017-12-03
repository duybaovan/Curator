//
//  CRTArticleRouter.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticleRouter.h"

#import "CRTArticle.h"
#import "CRTArticleManager.h"

#import <Realm/Realm.h>

@interface CRTArticleRouter()

@property (nonatomic) RLMResults<CRTArticle *> *results;

@end

@implementation CRTArticleRouter

- (instancetype)init {
    self = [super init];
    if(self) {
        self.results = [[CRTArticleManager sharedArticleManager]articles];
    }
    return self;
}


- (NSURL *)markArticleAsReal : (BOOL)isReal;{
    NSString *currentArticleID = self.results[self.selectedIndex].serverID;
    [[CRTArticleManager sharedArticleManager]markArticleWithID:currentArticleID asReal:isReal];
    
    self.selectedIndex++;
    if(self.selectedIndex >= self.results.count) {
        return nil;
    } else {
        return [NSURL URLWithString:self.results[self.selectedIndex].url];
    }
    
}


- (CRTArticle *)currentArticle {
    return [self articleAtIndex:self.selectedIndex];
}



- (CRTArticle *)articleAtIndex : (NSInteger)index {
    return self.results[index];
}

- (NSInteger)numberOfArticles {
    return self.results.count;
}


@end
