//
//  RNMenuHeader.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNMenuHeader : UIView {
@private
    UILabel *_titleLbl;
    UIImageView *_div;
}

@property (nonatomic, strong) NSString *title;

@end
