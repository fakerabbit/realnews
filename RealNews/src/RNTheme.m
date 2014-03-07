//
//  RNTheme.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNTheme.h"

@implementation RNTheme

/*
 * Fonts
 */

NSString * const kRNThemeFontHelvetica          = @"Helvetica";
NSString * const kRNThemeFontHelveticaBold      = @"Helvetica-Bold";
NSString * const kRNThemeFontHelveticaNeue      = @"HelveticaNeue";
NSString * const kRNThemeFontHelveticaNeueBold  = @"HelveticaNeue-Bold";

/*
 * Colors
 */

/**
 * Returns the yellow color used in the stream view's cell label.
 */
+ (UIColor*)colorStreamViewCellYellow {
    CGFloat red = 244.f/255.f;
    CGFloat green = 226.f/255.f;
    CGFloat blue = 126.f/255.f;
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: 1.f];
}

@end
