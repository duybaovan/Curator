//
//  CRTArticlePreviewTableViewCell.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRTArticlePreviewTableViewCell : UITableViewCell

- (void)configureWith : (NSURL *)imageURL
         articleTitle : (NSString *)title
    articleDescription: (NSString *)description;

@end
