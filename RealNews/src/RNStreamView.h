//
//  RNStreamView.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBXML.h"

@class RNStreamView;
@protocol IRNStreamViewDelegate <NSObject>
-(void)streamViewOnDrag:(CGPoint)pDragPoint;
@end

@interface RNStreamView : UIView <UICollectionViewDataSource, UICollectionViewDelegate> {
@private
    UIButton *_menuBtn;
    UILabel *_titleLbl;
    
    UIImageView *_leftShadowIv;
    UIImageView *_titleShadowIv;
    NSMutableDictionary *_handler;
    
    UICollectionView *_feedsCv;
    UIRefreshControl *_refreshCtrl;
    
    NSMutableArray *_allEntries;
    TBXML *_tbxml;
	NSString *_currentElement;
	NSMutableDictionary *_currentItem;
}

@property (nonatomic, weak) id <IRNStreamViewDelegate> delegate;
typedef void (^RNStreamViewOnMenu)(RNStreamView*);
@property (nonatomic, copy) RNStreamViewOnMenu onMenu;
typedef void (^RNStreamViewOnCell)(RNStreamView*);
@property (nonatomic, copy) RNStreamViewOnCell onCell;
@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleDesc;
@property (nonatomic, strong) NSArray *feeds;

- (void)clearFeeds;
- (void)loadFeeds;
- (void)appeared:(BOOL)pVisible;

@end
