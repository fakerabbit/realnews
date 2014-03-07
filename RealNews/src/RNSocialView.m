//
//  RNSocialView.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNSocialView.h"

#import "RNImages.h"

@interface RNSocialView (Private)
-(void)onEmailButton;
-(void)onFbButton;
-(void)onTwButton;
@end

@implementation RNSocialView

@synthesize delegate = _delegate;

#define kBNSocialViewLeftPadding 50.f

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Create the social toolbar
        _socialTb = [[UIToolbar alloc] initWithFrame: CGRectZero];
        _socialTb.barStyle = UIBarStyleDefault;
        //_socialTb.alpha = 0.9f;
        [self addSubview: _socialTb];
        
        // Create the buttons
        _emailBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [_emailBtn setBackgroundImage: [UIImage imageNamed: kRNImageEmailBtn] forState: UIControlStateNormal];
        [_emailBtn addTarget: self action: @selector(onEmailButton) forControlEvents: UIControlEventTouchDown];
        [_emailBtn sizeToFit];
        [self addSubview: _emailBtn];
        
        _fbBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [_fbBtn setBackgroundImage: [UIImage imageNamed: kRNImageFacebookBtn] forState: UIControlStateNormal];
        [_fbBtn addTarget: self action: @selector(onFbButton) forControlEvents: UIControlEventTouchDown];
        [_fbBtn sizeToFit];
        [self addSubview: _fbBtn];
        
        _twBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [_twBtn setBackgroundImage: [UIImage imageNamed: kRNImageTwitterBtn] forState: UIControlStateNormal];
        [_twBtn addTarget: self action: @selector(onTwButton) forControlEvents: UIControlEventTouchDown];
        [_twBtn sizeToFit];
        [self addSubview: _twBtn];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _socialTb.frame = CGRectMake(0.f, 0.f, w, h);
    _emailBtn.frame = CGRectMake(kBNSocialViewLeftPadding, h/2.f - _emailBtn.frame.size.width/2.f, _emailBtn.frame.size.width, _emailBtn.frame.size.height);
    _fbBtn.frame = CGRectMake(w/2.f - _fbBtn.frame.size.width/2.f, h/2.f - _fbBtn.frame.size.width/2.f, _fbBtn.frame.size.width, _fbBtn.frame.size.height);
    _twBtn.frame = CGRectMake(w - kBNSocialViewLeftPadding - _twBtn.frame.size.width, h/2.f - _twBtn.frame.size.width/2.f, _twBtn.frame.size.width, _twBtn.frame.size.height);
}

#pragma mark - Private

- (void)onEmailButton {
    [_delegate socialViewOnEmail: self];
}

- (void)onFbButton {
    [_delegate socialViewOnFacebook: self];
}

- (void)onTwButton {
    [_delegate socialViewOnTwitter: self];
}

@end
