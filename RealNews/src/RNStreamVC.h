//
//  RNStreamVC.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RNStreamView.h"

@class RNStreamVC;
@protocol IRNStreamVCDelegate <NSObject>
-(void)streamVCOnDrag:(CGPoint)pDragPoint;
@end

@interface RNStreamVC : UIViewController <IRNStreamViewDelegate> {
@private
    RNStreamView *_cview;
    
    NSMutableDictionary *_handler;
    BOOL _bInitialLoad;
}

@property (nonatomic, weak) id <IRNStreamVCDelegate> delegate;
typedef void (^RNStreamVCOnMenu)(RNStreamVC*);
@property (nonatomic, copy) RNStreamVCOnMenu onMenu;
typedef void (^RNStreamVCOnNews)(RNStreamVC*);
@property (nonatomic, copy) RNStreamVCOnNews onNews;
@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleDesc;
@property (nonatomic, strong) NSArray *feeds;

- (void)clearViewsFeeds;
- (void)loadViewFeeds;

@end
