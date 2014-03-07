//
//  RNMenuHeader.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNMenuHeader.h"

#import "RNTheme.h"
#import "RNImages.h"

@implementation RNMenuHeader

#define kBNMenuHeaderLeftPadding 15.f
#define kBNMenuHeaderTopPadding 5.f

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: kRNImageSourcesTile]];
        
        // Create label
        _titleLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_titleLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 24.f]];
        [_titleLbl setTextColor: [UIColor whiteColor]];
        _titleLbl.shadowColor = [UIColor blackColor];
        _titleLbl.shadowOffset = CGSizeMake(1.5f, 1.2f);
        [self addSubview: _titleLbl];
        
        // Create the div
        UIImage *shadowImg2 = [UIImage imageNamed: kRNImageSourcesDiv];
        shadowImg2 = [shadowImg2 resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg2.size.height/2.f, 0.f, shadowImg2.size.height/2.f, 0.f)];
        _div = [[UIImageView alloc] initWithImage: shadowImg2];
        [self addSubview: _div];
    }
    return self;
}

#pragma mark - Setup

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLbl setText: _title];
    [_titleLbl sizeToFit];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _titleLbl.frame = CGRectMake(kBNMenuHeaderLeftPadding, h/2.f - _titleLbl.frame.size.height/2.f, _titleLbl.frame.size.width, _titleLbl.frame.size.height);
    _div.frame = CGRectMake(0.f, h - _div.frame.size.height, w, _div.frame.size.height);
}

@end
