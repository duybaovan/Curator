//
//  CRTArticlePreviewTableViewCell.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRTArticle;

@interface CRTArticlePreviewTableViewCell : UITableViewCell

- (void)configureWithArticle : (CRTArticle *)article;

@end
