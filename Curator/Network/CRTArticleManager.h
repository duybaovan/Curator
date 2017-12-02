//
//  CRTArticleManager.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@interface CRTArticleManager : NSObject

+ (instancetype)sharedArticleManager;
- (BFTask *)getArticleWithURL : (NSURL *)url;

@end
