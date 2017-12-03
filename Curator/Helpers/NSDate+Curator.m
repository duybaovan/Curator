//
//  NSDate+Curator.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "NSDate+Curator.h"

@implementation NSDate (Curator)

+ (NSDate*)dateFromISOStringWithoutSeconds : (NSString *)string {
    static dispatch_once_t once;
    static NSDateFormatter *_sharedInstance;
    dispatch_once(&once, ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        _sharedInstance = dateFormatter;
    });
    
    return [_sharedInstance dateFromString:string];
}

@end
