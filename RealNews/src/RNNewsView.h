//
//  RNNewsView.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RNSocialView.h"

@interface RNNewsView : UIView <UIWebViewDelegate, IRNSocialViewDelegate> {
@private
    UIImageView *_titleShadowIv;
    UILabel *_titleLbl;
    UIButton *_backBtn;
    UIButton *_shareBtn;
    
    UIWebView *_webView;
    UIActivityIndicatorView *_loading;
    
    RNSocialView *_socialView;
    
    NSMutableDictionary *_handler;
}

typedef void (^RNNewsViewOnBack)(RNNewsView*);
@property (nonatomic, copy) RNNewsViewOnBack onBack;
typedef void (^RNNewsViewOnEmail)(RNNewsView*);
@property (nonatomic, copy) RNNewsViewOnEmail onEmail;
typedef void (^RNNewsViewOnFacebook)(RNNewsView*);
@property (nonatomic, copy) RNNewsViewOnFacebook onFacebook;
typedef void (^RNNewsViewOnTwitter)(RNNewsView*);
@property (nonatomic, copy) RNNewsViewOnTwitter onTwitter;
@property (nonatomic, strong) NSString *articleUrl;

@end
