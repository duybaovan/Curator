//
//  CRTArticle.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "CRTArticle.h"

@implementation CRTArticle

+ (CRTArticle *)articleFromDictionary: (NSDictionary *)dictionary {
    
    NSString *serverID = dictionary[@"id"];
    
    CRTArticle *article = [CRTArticle objectForPrimaryKey:serverID];
    if(!article) {
        article = [[CRTArticle alloc]init];
        article.serverID = serverID;
    }
    
    article.summary = dictionary[@"description"];
    article.numberUpvotes = ((NSNumber *)dictionary[@"realCount"]).integerValue;
    article.numberDownvotes = ((NSNumber *)dictionary[@"fakeCount"]).integerValue;
    article.title = dictionary[@"title"];
    article.url = dictionary[@"url"];
    article.photoURL = dictionary[@"urlToImage"];
    
    
    return article;
}


+ (NSString *)primaryKey {
    return @"serverID";
}

@end
