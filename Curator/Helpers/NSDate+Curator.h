//
//  NSDate+Curator.h
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Curator)

+ (NSDate*)dateFromISOStringWithoutSeconds : (NSString *)string;


@end
