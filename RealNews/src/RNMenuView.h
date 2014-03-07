//
//  RNMenuView.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNMenuView : UIView <UITableViewDelegate, UITableViewDataSource> {
@private
    UIImageView *_logo;
    UIImageView *_titleShadowIv;
    
    UITableView *_sourcesTv;
    NSMutableDictionary *_handler;
}

typedef void (^RNMenuViewOnSource)(RNMenuView*);
@property (nonatomic, copy) RNMenuViewOnSource onSource;
typedef void (^RNMenuViewOnClearFeeds)(RNMenuView*);
@property (nonatomic, copy) RNMenuViewOnClearFeeds onClearFeeds;
@property (nonatomic, strong) NSArray *sourcesArray;
@property (nonatomic, strong) NSArray *spanishSourcesArray;
@property (nonatomic, strong) NSArray *twitterSourcesArray;
@property (nonatomic) NSUInteger selectedRow;
@property (nonatomic) NSUInteger selectedSection;

- (void)selectDefaultSource;

@end
