//
//  CRTArticleRouter.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticleRouter.h"

@interface CRTArticleRouter()

@property (nonatomic) NSArray<NSURL *> *results;

@end

@implementation CRTArticleRouter


- (NSURL *)markArticleAsReal : (BOOL)isReal;{
    //Mark the current article selected.
    return [NSURL URLWithString:@"https://techcrunch.com/2017/12/01/psa-is-your-iphone-suddenly-crashing-heres-why-and-how-to-fix-it/"];
    self.selectedIndex++;
    if(self.selectedIndex >= self.results.count) {
        return nil;
    } else {
        return self.results[self.selectedIndex];
    }
    
}


@end
