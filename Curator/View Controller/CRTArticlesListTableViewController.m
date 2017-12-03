//
//  CRTArticlesListTableViewController.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticlesListTableViewController.h"
#import "CRTArticlePreviewTableViewCell.h"
#import "CRTArticleViewController.h"
#import "CRTArticleRouter.h"
#import "CRTArticleManager.h"

#import <Bolts/Bolts.h>

@interface CRTArticlesListTableViewController ()

@property (nonatomic) CRTArticleRouter *articleRouter;

@end

static NSString * const kCRTArticleListReuseIdentifier = @"com.curator.article_list.tvc.identifier";

@implementation CRTArticlesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[CRTArticlePreviewTableViewCell class] forCellReuseIdentifier:kCRTArticleListReuseIdentifier];
    self.tableView.rowHeight = 120;
    self.articleRouter = [CRTArticleRouter new];
    [self reloadArticlesFromServer];

    

}

- (void)reloadArticlesFromServer {
    [[[CRTArticleManager sharedArticleManager]downloadArticles]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleRouter != nil ? [self.articleRouter numberOfArticles] : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRTArticlePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCRTArticleListReuseIdentifier forIndexPath:indexPath];
 
    [cell configureWithArticle:[self.articleRouter articleAtIndex:indexPath.row]];
 
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRTArticleViewController *articleVC = [[CRTArticleViewController alloc]init];
    self.articleRouter.selectedIndex = indexPath.row;
    articleVC.articleSource = self.articleRouter;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
