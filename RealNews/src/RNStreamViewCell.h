//
//  RNStreamViewCell.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNStreamViewCell : UICollectionViewCell {
@private
    UIImageView *_imgShadowIv;
    UIImageView *_bgIv;
    UIWebView *_imageWv;
    UILabel *_dateTimeLbl;
    UITextView *_titleTv;
    UILabel *_sourceLbl;
}

@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic) BOOL localImg;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSAttributedString *message;
@property (nonatomic, strong) NSString *source;

@end
