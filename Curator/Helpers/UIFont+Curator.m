//
//  UIFont+Curator.m
//  Curator
//
//  Created by Jason Scharff on 12/2/17.
//  Copyright © 2017 Jason Felix Scharff. All rights reserved.
//

#import "UIFont+Curator.h"

@implementation UIFont (Curator)

+ (UIFont *)crt_headerFont {
    static dispatch_once_t onceToken;
    static UIFont *headerFont;
    dispatch_once(&onceToken, ^{
        headerFont = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    });
    return headerFont;
}

+ (UIFont *)crt_bodyFont {
    static dispatch_once_t onceToken;
    static UIFont *bodyFont;
    dispatch_once(&onceToken, ^{
        bodyFont = [UIFont systemFontOfSize:12.0 weight:UIFontWeightThin];
    });
    return bodyFont;
}

@end
