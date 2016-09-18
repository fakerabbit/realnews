//
//  RNNewsView.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNNewsView.h"

#import "RNImages.h"
#import "RNTheme.h"

@interface RNNewsView (Private)
-(void)onBackButton;
-(void)onShareButton;
@end

@implementation RNNewsView

#define kBNNewsViewBackBtnLeftPad 5.f
#define kBNNewsViewBackBtnTopPad 20.f
#define kBNNewsViewMenuBtnTopPad 52.5f
#define kBNNewsViewSocialH 80.f

NSTimeInterval const kBNNewsViewToolbarAnimationDuration  = 0.3;

NSString * const kBNNewsViewBackHandlerKey     = @"news view back handler";
NSString * const kBNNewsViewEmailHandlerKey    = @"news view email handler";
NSString * const kBNNewsViewFacebookHandlerKey = @"news view facebook handler";
NSString * const kBNNewsViewTwitterHandlerKey  = @"news view twitter handler";

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _handler = [NSMutableDictionary dictionary];
        
        // Create the web view
        _webView = [[UIWebView alloc] initWithFrame: CGRectZero];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self addSubview: _webView];
        
        // Create shadows
        UIImage *shadowImg = [UIImage imageNamed: kRNImageStreamTitleShadow];
        shadowImg = [shadowImg resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg.size.height/2.f, 0.f, shadowImg.size.height/2.f, 0.f)];
        _titleShadowIv = [[UIImageView alloc] initWithImage: shadowImg];
        [self addSubview: _titleShadowIv];
        
        // Create buttons
        UIImage *btnImage = [UIImage imageNamed: kRNImageBackBtn];
        btnImage = [btnImage resizableImageWithCapInsets: UIEdgeInsetsMake(0, btnImage.size.width/2.f, 0, btnImage.size.width/2.f)];
        _backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_backBtn setBackgroundImage: btnImage forState: UIControlStateNormal];
        [_backBtn addTarget:self action: @selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn sizeToFit];
        [self addSubview: _backBtn];
        
        _shareBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [_shareBtn setBackgroundImage: [UIImage imageNamed: kRNImageShareBtn] forState: UIControlStateNormal];
        [_shareBtn addTarget: self action: @selector(onShareButton) forControlEvents: UIControlEventTouchDown];
        [_shareBtn sizeToFit];
        [self addSubview: _shareBtn];
        
        // Create title label
        _titleLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_titleLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 24.f]];
        [_titleLbl setTextColor: [UIColor blackColor]];
        [_titleLbl setText: @"Madrid News"];
        [_titleLbl sizeToFit];
        [self addSubview: _titleLbl];
        
        // Create activity indicator
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        _loading.hidesWhenStopped = YES;
        [self addSubview: _loading];
        
        // Create the social toolbar
        _socialView = [[RNSocialView alloc] initWithFrame: CGRectZero];
        _socialView.delegate = self;
        [self addSubview: _socialView];
    }
    return self;
}

#pragma mark - Setup

- (void)setOnBack:(RNNewsViewOnBack)onBack {
    [_handler setValue: [onBack copy] forKey: kBNNewsViewBackHandlerKey];
}

- (void)setOnEmail:(RNNewsViewOnEmail)onEmail {
    [_handler setValue: [onEmail copy] forKey: kBNNewsViewEmailHandlerKey];
}

- (void)setOnFacebook:(RNNewsViewOnFacebook)onFacebook {
    [_handler setValue: [onFacebook copy] forKey: kBNNewsViewFacebookHandlerKey];
}

- (void)setOnTwitter:(RNNewsViewOnTwitter)onTwitter {
    [_handler setValue: [onTwitter copy] forKey: kBNNewsViewTwitterHandlerKey];
}

- (void)setArticleUrl:(NSString *)articleUrl {
    _articleUrl = articleUrl;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: _articleUrl]]];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _backBtn.frame = CGRectMake(kBNNewsViewBackBtnLeftPad, kBNNewsViewBackBtnTopPad, _backBtn.frame.size.width, _backBtn.frame.size.height);
    _shareBtn.frame = CGRectMake(w - kBNNewsViewBackBtnLeftPad - _shareBtn.frame.size.width, kBNNewsViewBackBtnTopPad, _shareBtn.frame.size.width, _shareBtn.frame.size.height);
    _titleLbl.frame = CGRectMake(w/2.f - _titleLbl.frame.size.width/2.f, kBNNewsViewBackBtnTopPad, _titleLbl.frame.size.width, _titleLbl.frame.size.height);
    _titleShadowIv.frame = CGRectMake(0.f, kBNNewsViewMenuBtnTopPad, w, _titleShadowIv.frame.size.height);
    _webView.frame = CGRectMake(0.f, kBNNewsViewMenuBtnTopPad, w, h - kBNNewsViewMenuBtnTopPad);
    _loading.frame = CGRectMake(w/2.f - _loading.frame.size.width/2.f, h/2.f - _loading.frame.size.height/2.f, _loading.frame.size.width, _loading.frame.size.height);
    _socialView.frame = CGRectMake(0.f, h, w, kBNNewsViewSocialH);
}

#pragma mark - Private

- (void)onBackButton {
    RNNewsViewOnBack handler = [_handler valueForKey: kBNNewsViewBackHandlerKey];
    if (handler)
        handler(self);
}

- (void)onShareButton {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat th = h;
    
    if (_socialView.frame.origin.y >= h)
        th = h - kBNNewsViewSocialH;
    
    [UIView animateWithDuration: kBNNewsViewToolbarAnimationDuration animations: ^() {
        _socialView.frame = CGRectMake(0, th, w, kBNNewsViewSocialH);
    }
                     completion: ^(BOOL finished) {
                         //NSLog(@"done!");
                     }];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"error: %ld", (long)error.code);
    if (error.code == -1001) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred, please check your internet connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loading startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loading stopAnimating];
}

#pragma mark - IBNSocialViewDelegate Methods

- (void)socialViewOnEmail:(RNSocialView *)pSocialView {
    [self onShareButton];
    RNNewsViewOnEmail handler = [_handler valueForKey: kBNNewsViewEmailHandlerKey];
    if (handler)
        handler(self);
}

- (void)socialViewOnFacebook:(RNSocialView *)pSocialView {
    [self onShareButton];
    RNNewsViewOnFacebook handler = [_handler valueForKey: kBNNewsViewFacebookHandlerKey];
    if (handler)
        handler(self);
}

- (void)socialViewOnTwitter:(RNSocialView *)pSocialView {
    [self onShareButton];
    RNNewsViewOnTwitter handler = [_handler valueForKey: kBNNewsViewTwitterHandlerKey];
    if (handler)
        handler(self);
}

@end
