//
//  CRTArticle.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Realm/Realm.h>

@interface CRTArticle : RLMObject

@property NSString *title;
@property NSString *summary;
@property NSString *url;
@property NSString *photoURL;

@property NSString *serverID;

@property NSString *content;
@property BOOL isRead;
@property NSDate *publishedDate;

@property NSInteger numberUpvotes;
@property NSInteger numberDownvotes;

+ (CRTArticle *)articleFromDictionary: (NSDictionary *)dictionary;

@end


// This protocol enables typed collections. i.e.:
// RLMArray<CRTArticle *><CRTArticle>
RLM_ARRAY_TYPE(CRTArticle)
