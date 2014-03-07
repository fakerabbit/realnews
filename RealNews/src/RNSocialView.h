//
//  RNSocialView.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RNSocialView;
@protocol IRNSocialViewDelegate <NSObject>
-(void)socialViewOnEmail:(RNSocialView*)pSocialView;
-(void)socialViewOnFacebook:(RNSocialView*)pSocialView;
-(void)socialViewOnTwitter:(RNSocialView*)pSocialView;
@end

@interface RNSocialView : UIView {
@private
    UIToolbar *_socialTb;
    UIButton *_emailBtn;
    UIButton *_fbBtn;
    UIButton *_twBtn;
}

@property (nonatomic, weak) id <IRNSocialViewDelegate> delegate;

@end
