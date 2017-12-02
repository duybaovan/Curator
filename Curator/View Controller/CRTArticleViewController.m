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

@property WKWebView *webView;

@end

@implementation CRTArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
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
    

    
}

- (NSString *)generateHTMLWithTitle : (NSString *)title andContent: (NSString *)content {
    NSString *html = [NSString stringWithFormat:@"<style>body{font: normal 26px Arial, sans-serif;}</style><h1 style=font: bold 46px Arial, sans-serif; margin-top:20px;>%@</h1>%@", title, content];
    return html;
    
}






@end
