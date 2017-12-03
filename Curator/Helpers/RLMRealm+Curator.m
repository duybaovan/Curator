//
//  RLMRealm+Curator.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "RLMRealm+Curator.h"


@implementation RLMRealm (Curator)

- (BFTask *)crt_TransactionWithBlock: (void (^)(void))block {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSError *error;
    BOOL result = [self transactionWithBlock:block error:&error];
    [completionSource setResult:@(result)];
    if(error) {
        [completionSource setError:error];
    }
    return completionSource.task;
}

@end
