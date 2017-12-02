//
//  CRTArticleRouter.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRTArticleRouterDelegate

- (NSURL *)markArticle : (BOOL)isReal;

@end

@interface CRTArticleRouter : NSObject <CRTArticleRouterDelegate>

- (NSURL *)markArticle : (BOOL)isReal;

@end
