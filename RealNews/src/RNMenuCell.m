//
//  RNMenuCell.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNMenuCell.h"

#import "RNTheme.h"
#import "RNImages.h"

@implementation RNMenuCell

#define kBNMenuCellLeftPadding 30.f
#define kBNMenuCellTopPadding 5.f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.cornerRadius = 7;
        bgColorView.layer.masksToBounds = YES;
        [self setSelectedBackgroundView: bgColorView];
        
        // Create the bg
        UIImage *bgImg = [[UIImage imageNamed: kRNImageSourcesBg] stretchableImageWithLeftCapWidth: 8 topCapHeight: 10];
        _bgIv = [[UIImageView alloc] initWithImage: bgImg];
        _bgIv.backgroundColor = [UIColor clearColor];
        _bgIv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //[self.contentView addSubview: _bgIv];
        
        // Create label
        _titleLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_titleLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 18.f]];
        [_titleLbl setTextColor: [UIColor whiteColor]];
        //_titleLbl.shadowColor = [UIColor blackColor];
        //_titleLbl.shadowOffset = CGSizeMake(1.5f, 1.2f);
        [self.contentView addSubview: _titleLbl];
        
        // Create the div
        UIImage *shadowImg2 = [UIImage imageNamed: kRNImageSourcesDiv];
        shadowImg2 = [shadowImg2 resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg2.size.height/2.f, 0.f, shadowImg2.size.height/2.f, 0.f)];
        _div = [[UIImageView alloc] initWithImage: shadowImg2];
        [self.contentView addSubview: _div];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    _bgIv.hidden = !selected;
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
    
    _titleLbl.frame = CGRectMake(kBNMenuCellLeftPadding, h/2.f - _titleLbl.frame.size.height/2.f, _titleLbl.frame.size.width, _titleLbl.frame.size.height);
    _div.frame = CGRectMake(0.f, h - _div.frame.size.height, w, _div.frame.size.height);
    _bgIv.frame = CGRectMake(0.f, 0.f, w, _bgIv.frame.size.height);
}

@end
