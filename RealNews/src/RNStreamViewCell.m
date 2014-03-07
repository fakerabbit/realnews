//
//  RNStreamViewCell.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNStreamViewCell.h"

#import "RNTheme.h"
#import "RNImages.h"

@implementation RNStreamViewCell

#define kBNStreamViewCellLeftPad 10.f
#define kBNStreamViewCellTopPad 5.f
#define kBNStreamViewCellBottomPad 5.f
#define kBNStreamViewCellImgPad 5.f

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgIv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:kRNImageStreamImgBg]];
        _bgIv.contentMode = UIViewContentModeScaleToFill;
        _bgIv.layer.cornerRadius = 9.0;
        _bgIv.layer.masksToBounds = YES;
        _bgIv.userInteractionEnabled = NO;
        [self addSubview: _bgIv];
        
        _imageWv = [[UIWebView alloc] initWithFrame: CGRectZero];
        _imageWv.scalesPageToFit = YES;
        _imageWv.userInteractionEnabled = NO;
        _imageWv.backgroundColor = [UIColor clearColor];
        _imageWv.layer.cornerRadius = 9.0;
        _imageWv.layer.masksToBounds = YES;
        _imageWv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _imageWv.layer.borderWidth = .5f;
        [self addSubview: _imageWv];
        
        // Create the shadows
        UIImage *shadowImg = [UIImage imageNamed: kRNImageStreamImgShadow];
        shadowImg = [shadowImg resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg.size.height/2.f, 0.f, shadowImg.size.height/2.f, 0.f)];
        _imgShadowIv = [[UIImageView alloc] initWithImage: shadowImg];
        _imgShadowIv.contentMode = UIViewContentModeScaleToFill;
        _imgShadowIv.layer.cornerRadius = 9.0;
        _imgShadowIv.layer.masksToBounds = YES;
        _imgShadowIv.userInteractionEnabled = NO;
        [self addSubview: _imgShadowIv];
        
        _dateTimeLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_dateTimeLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 10.f]];
        [_dateTimeLbl setTextColor: [UIColor lightGrayColor]];
        [_dateTimeLbl setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _dateTimeLbl];
        
        _titleTv = [[UITextView alloc] initWithFrame: CGRectZero];
        _titleTv.editable = NO;
        _titleTv.scrollEnabled = NO;
        _titleTv.userInteractionEnabled = NO;
        [_titleTv setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 20.f]];
        [_titleTv setTextColor: [UIColor whiteColor]];
        [_titleTv setBackgroundColor: [UIColor clearColor]];
        _titleTv.layer.shadowColor = [[UIColor blackColor] CGColor];
        _titleTv.layer.shadowOffset = CGSizeMake(1.5f, 1.2f);;
        [self addSubview: _titleTv];
        
        _sourceLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_sourceLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 12.f]];
        [_sourceLbl setTextColor: [RNTheme colorStreamViewCellYellow]];
        [_sourceLbl setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _sourceLbl];
    }
    return self;
}

#pragma mark - Setup

- (void)setImgUrl:(NSURL *)imgUrl {
    _imageWv.hidden = NO;
    _localImg = NO;
    
    _imgUrl = imgUrl;
    [_imageWv loadRequest: [NSURLRequest requestWithURL: _imgUrl]];
}

- (void)setLocalImg:(BOOL)localImg {
    _localImg = localImg;
    if (_localImg)
        _imageWv.hidden = YES;
    else
        _imageWv.hidden = NO;
}

- (void)setDateTime:(NSString *)dateTime {
    _dateTime = dateTime;
    [_dateTimeLbl setText: _dateTime];
    [_dateTimeLbl sizeToFit];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleTv setText: _title];
    [_titleTv sizeToFit];
    [self layoutIfNeeded];
}

- (void)setSource:(NSString *)source {
    _source = source;
    [_sourceLbl setText: _source];
    [_sourceLbl sizeToFit];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _imageWv.frame = CGRectMake(kBNStreamViewCellImgPad, 0.f, w - kBNStreamViewCellImgPad * 2.f, h);
    _bgIv.frame = _imageWv.frame;
    _imgShadowIv.frame = CGRectMake(_imageWv.frame.origin.x, h/2.f, _imageWv.frame.size.width, h/2.f);
    _dateTimeLbl.frame = CGRectMake(w - _dateTimeLbl.frame.size.width - kBNStreamViewCellLeftPad, h - _dateTimeLbl.frame.size.height - kBNStreamViewCellBottomPad, _dateTimeLbl.frame.size.width, _dateTimeLbl.frame.size.height);
    _sourceLbl.frame = CGRectMake(kBNStreamViewCellLeftPad, h - _sourceLbl.frame.size.height - kBNStreamViewCellBottomPad, _dateTimeLbl.frame.origin.x - kBNStreamViewCellLeftPad, _sourceLbl.frame.size.height);
    _titleTv.frame = CGRectMake(kBNStreamViewCellLeftPad, h/2.f, w - kBNStreamViewCellLeftPad * 2.f, h/2.f);
}

@end
