//
//  CRTArticlesListTableViewController.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticlesListTableViewController.h"
#import "CRTArticlePreviewTableViewCell.h"


@interface CRTArticlesListTableViewController ()

@end

static NSString * const kCRTArticleListReuseIdentifier = @"com.curator.article_list.tvc.identifier";

@implementation CRTArticlesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[CRTArticlePreviewTableViewCell class] forCellReuseIdentifier:kCRTArticleListReuseIdentifier];
    self.tableView.rowHeight = 120;
    

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
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRTArticlePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCRTArticleListReuseIdentifier forIndexPath:indexPath];
 
    [cell configureWith:[NSURL URLWithString:@"https://tctechcrunch2011.files.wordpress.com/2017/12/iph.png"] articleTitle:@"PSA: Is your iPhone suddenly crashing? Here’s why (and how to fix it" articleDescription:@"Is your iOS device rebooting itself seemingly at random this morning? You're not alone. Apple is having a pretty rough week when it comes to nasty software.."];
 
    return cell;
}




@end
