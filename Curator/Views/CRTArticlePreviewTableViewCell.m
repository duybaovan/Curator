//
//  CRTArticlePreviewTableViewCell.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticlePreviewTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIImageView+AFNetworking.h"


@interface CRTArticlePreviewTableViewCell ()

@property (nonatomic) UIImageView *previewImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;

@end

@implementation CRTArticlePreviewTableViewCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.previewImageView = [UIImageView new];
    self.previewImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    
    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    
    [AutolayoutHelper configureView:self.contentView
                           subViews:NSDictionaryOfVariableBindings(_previewImageView, _titleLabel, _descriptionLabel)
                        constraints:@[@"V:|-[_previewImageView]-|",
                                      @"V:|-[_titleLabel]-2-[_descriptionLabel]-(>=8)-|",
                                      @"H:|-[_previewImageView]-[_titleLabel]-|",
                                      @"X:_descriptionLabel.leading == _titleLabel.leading",
                                      @"X:_descriptionLabel.trailing == _titleLabel.trailing",
                                      @"X:_previewImageView.width == _previewImageView.height"]];
    
    
}

//Remove
- (void)configureWith : (NSURL *)imageURL
         articleTitle : (NSString *)title
    articleDescription: (NSString *)description {
    
    [self.previewImageView setImageWithURL:imageURL];
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}




@end
