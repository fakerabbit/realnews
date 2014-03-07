//
//  RNMenuVC.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RNStreamVC.h"
#import "RNNewsVC.h"
#import "RNMenuView.h"

@interface RNMenuVC : UIViewController <IRNStreamVCDelegate> {
@private
    RNMenuView *_cview;
    RNStreamVC *_streamVC;
    RNNewsVC *_newsVC;
    
    NSArray *_sourcesArray;
    NSInteger _selectedSection;
    NSUInteger _selectedRow;
    BOOL _bRefresh;
}

@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleDesc;

@end
