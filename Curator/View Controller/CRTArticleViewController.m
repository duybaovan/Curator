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

@end

static CGFloat const kCRTStartingScale = 0.5;

@implementation CRTArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureGestureRecognizers];
    if(self.articleURL) {
        [[[CRTArticleManager sharedArticleManager]getArticleWithURL:self.articleURL]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
    
            NSString *htmlString = [self generateHTMLWithTitle:@"Some title" andContent:t.result];
            [self.webView loadHTMLString:htmlString baseURL:nil];
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
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.rightImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kCRTStartingScale, kCRTStartingScale);
        self.rightImageView.center = [sender locationInView:self.view];
        self.rightImageView.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGPoint location = [sender locationInView:self.view];
        CGFloat ratio = 1 - (location.x / self.view.bounds.size.width);
        if (ratio > 0.6){
            //go to next article now.
        }
        CGFloat slope = (1 - kCRTStartingScale) / 0.5;
        CGFloat scale = MIN(kCRTStartingScale + slope * ratio, 1);
        self.rightImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        self.rightImageView.center = CGPointMake(self.rightImageView.center.x + translation.x, self.rightImageView.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.view];
        CGFloat ratio = 1 - (location.x / self.view.bounds.size.width);
        if(location.x > ratio) {
            self.rightImageView.hidden = YES;
            //go to the next article.
        }
    }
}

- (void)didPanFromLeft : (UIPanGestureRecognizer *)sender {
    NSLog(@"did pan from left");
}

- (NSString *)generateHTMLWithTitle : (NSString *)title andContent: (NSString *)content {
    NSString *html = [NSString stringWithFormat:@"<style>body{font: normal 26px Arial, sans-serif;}</style><h1 style=font: bold 46px Arial, sans-serif; margin-top:20px;>%@</h1>%@", title, content];
    return html;
    
}






@end
