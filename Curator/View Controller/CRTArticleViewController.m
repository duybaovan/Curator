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

@import WebKit;

@interface CRTArticleViewController ()

@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIImageView *rightImageView;
@property (nonatomic) UIImageView *leftImageView;
@property (nonatomic) UIActivityIndicatorView *loadingView;

@property (nonatomic) UIScreenEdgePanGestureRecognizer *rightGesture;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *leftGesture;

@end

static CGFloat const kCRTStartingScale = 0.5;

@implementation CRTArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureGestureRecognizers];
    if(self.articleURL) {
        self.articleURL = _articleURL;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)setArticleURL:(NSURL *)articleURL {
    _articleURL = articleURL;
    if(self.isViewLoaded && articleURL) {
        self.webView.hidden = YES;
        self.rightGesture.enabled = NO;
        self.leftGesture.enabled = NO;
        self.loadingView.hidden = NO;
        [[[CRTArticleManager sharedArticleManager]getArticleWithURL:articleURL]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
            NSString *htmlString = [self generateHTMLWithTitle:@"Some title" andContent:t.result];
            [self.webView loadHTMLString:htmlString baseURL:nil];
            self.loadingView.hidden = YES;
            self.webView.hidden = NO;
            self.rightGesture.enabled = YES;
            self.leftGesture.enabled = YES;
            return nil;
        }];
    }

    
}

- (void)configureViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc]init];
    
    [AutolayoutHelper configureView:self.view
                           subViews:NSDictionaryOfVariableBindings(_webView)
                        constraints:@[@"H:|[_webView]|",
                                      @"V:|[_webView]|"]];
    
    self.rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overlay_right"]];
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overlay_left"]];
    
    [self.view addSubview:self.rightImageView];
    [self.view addSubview:self.leftImageView];
    self.rightImageView.hidden = YES;
    self.leftImageView.hidden = YES;
    
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.tintColor = [UIColor blackColor];
    
    [AutolayoutHelper configureView:self.view subViews:NSDictionaryOfVariableBindings(_loadingView)
                        constraints:@[@"X:_loadingView.centerX == superview.centerX",
                                      @"X:_loadingView.centerY == superview.centerY"]];
    
    [self.loadingView startAnimating];
    
    

    
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
        if (ratio > 0.6){
            view.hidden = YES;
            self.articleURL = [self.articleSource markArticleAsReal:fromRight];
            return;
        }
        CGFloat slope = (1 - kCRTStartingScale) / 0.5;
        CGFloat scale = MIN(kCRTStartingScale + slope * ratio, 1);
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.view];
        CGFloat ratio = fromRight ? 1 - (location.x / self.view.bounds.size.width) : (location.x / self.view.bounds.size.width);
        if(ratio > 0.2) {
            self.articleURL = [self.articleSource markArticleAsReal:fromRight];
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
