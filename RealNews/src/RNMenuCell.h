//
//  RNMenuCell.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNMenuCell : UITableViewCell {
@private
    UILabel *_titleLbl;
    UIImageView *_div;
    UIImageView *_bgIv;
}

@property (nonatomic, strong) NSString *title;

@end
