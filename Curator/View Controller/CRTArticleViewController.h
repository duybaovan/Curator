//
//  CRTArticleViewController.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRTArticleRouter.h"

@interface CRTArticleViewController : UIViewController

@property (nonatomic) NSURL *articleURL;
@property (nonatomic, weak)id <CRTArticleRouterDelegate> articleSource;


@end
