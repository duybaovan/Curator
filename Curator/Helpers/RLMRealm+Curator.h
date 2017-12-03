//
//  RLMRealm+Curator.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Bolts/Bolts.h>
#import <Realm/Realm.h>

@interface RLMRealm (Curator)

- (BFTask *)crt_TransactionWithBlock: (void (^)(void))block;

@end
