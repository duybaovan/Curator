//
//  CRTArticleViewController.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticleViewController.h"

#import <Bolts/Bolts.h>

#import "AutolayoutHelper.h"
#import "UIFont+Curator.h"

#import "CRTArticleManager.h"
#import "CRTArticle.h"

@import WebKit;

@interface CRTArticleViewController ()

@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIImageView *rightImageView;
@property (nonatomic) UIImageView *leftImageView;

@property (nonatomic) UIScreenEdgePanGestureRecognizer *rightGesture;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *leftGesture;

@property (nonatomic) UIProgressView * percentageFakeView;

@end

static CGFloat const kCRTStartingScale = 0.5;

@implementation CRTArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureGestureRecognizers];
    [self loadArticle];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.translucent = NO;

}

- (void)loadArticle {
    CRTArticle *article = [self.articleSource currentArticle];
    NSURL *articleURL = [NSURL URLWithString:article.url];
    if(self.isViewLoaded && articleURL) {
        self.webView.hidden = YES;
        self.rightGesture.enabled = NO;
        self.leftGesture.enabled = NO;
        if(article.numberDownvotes + article.numberUpvotes == 0) {
            self.percentageFakeView.progress = 0;
        } else {
            self.percentageFakeView.progress = (float)article.numberDownvotes / (float) (article.numberUpvotes + article.numberDownvotes);
        }
        
        _percentageFakeView.hidden = YES;
        NSString *htmlString = [self generateHTMLWithTitle:article.title andContent:article.content];
            
        [self.webView loadHTMLString:htmlString baseURL:nil];
        _percentageFakeView.hidden = NO;
        self.webView.hidden = NO;
        self.rightGesture.enabled = YES;
        self.leftGesture.enabled = YES;
    }

    
}

- (void)configureViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.percentageFakeView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.percentageFakeView.trackTintColor = [UIColor colorWithRed:39.0/255.0f
                                                             green:174.0/255.0
                                                              blue:96.0/255.0
                                                             alpha:1.0];
    
    self.percentageFakeView.progressTintColor = [UIColor colorWithRed:192.0/255.0
                                                                green:57.0/255.0
                                                                 blue:43.0/255.0
                                                                alpha:1.0];
    
    
    self.webView = [[WKWebView alloc]init];
    
    [AutolayoutHelper configureView:self.view
                           subViews:NSDictionaryOfVariableBindings(_webView, _percentageFakeView)
                        constraints:@[@"H:|[_webView]|",
                                      @"H:|[_percentageFakeView]|",
                                      @"V:|[_percentageFakeView(10)][_webView]|"]];
    
    self.rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overlay_right"]];
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overlay_left"]];
    
    [self.view addSubview:self.rightImageView];
    [self.view addSubview:self.leftImageView];
    self.rightImageView.hidden = YES;
    self.leftImageView.hidden = YES;
    
    
    
    

    
}

- (void)configureGestureRecognizers {
    UIScreenEdgePanGestureRecognizer *leftGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanFromLeft:)];
    leftGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftGesture];
    
    UIScreenEdgePanGestureRecognizer *rightGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanFromRight:)];
    rightGesture.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:rightGesture];
    
}

- (void)didPanFromRight : (UIPanGestureRecognizer *)sender {
    [self didPan:sender isFromRight:YES];
}

- (void)didPan : (UIPanGestureRecognizer *)sender isFromRight: (BOOL)fromRight {
    UIView *view = fromRight ? self.rightImageView : self.leftImageView;
    if(sender.state == UIGestureRecognizerStateBegan) {
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kCRTStartingScale, kCRTStartingScale);
        view.center = [sender locationInView:self.view];
        view.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGPoint location = [sender locationInView:self.view];
        CGFloat ratio = fromRight ? 1 - (location.x / self.view.bounds.size.width) : (location.x / self.view.bounds.size.width);
        CGFloat slope = (1 - kCRTStartingScale) / 0.5;
        CGFloat scale = MIN(kCRTStartingScale + slope * ratio, 1);
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.view];
        CGFloat ratio = fromRight ? 1 - (location.x / self.view.bounds.size.width) : (location.x / self.view.bounds.size.width);
        if(ratio > 0.2) {
            [self.articleSource markArticleAsReal:fromRight];
            [self loadArticle];
        }
        view.hidden = YES;
    }
    
}

- (void)didPanFromLeft : (UIPanGestureRecognizer *)sender {
    [self didPan:sender isFromRight:NO];
}

- (NSString *)generateHTMLWithTitle : (NSString *)title andContent: (NSString *)content {
    NSString *html = [NSString stringWithFormat:@"<style>body{font: normal 26px Arial, sans-serif;}</style><h1 style=font: bold 46px Arial, sans-serif; margin-top:20px;>%@</h1>%@", title, content];
    return html;
    
}






@end
