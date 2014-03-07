//
//  RNStreamVC.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNStreamVC.h"

@interface RNStreamVC ()
-(void)onMenuView;
-(void)onCell:(RNStreamView*)pStreamView;
@end

@implementation RNStreamVC

@synthesize delegate = _delegate;

NSString * const kBNStreamVCMenuHandlerKey = @"stream vc menu handler";
NSString * const kBNStreamVCNewsHandlerKey = @"stream vc news handler";

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _handler = [NSMutableDictionary dictionary];
        _bInitialLoad = YES;
    }
    return self;
}

#pragma mark - Setup

- (void)setOnMenu:(RNStreamVCOnMenu)onMenu {
    [_handler setValue: [onMenu copy] forKey: kBNStreamVCMenuHandlerKey];
}

- (void)setOnNews:(RNStreamVCOnNews)onNews {
    [_handler setValue: [onNews copy] forKey: kBNStreamVCNewsHandlerKey];
}

- (void)setFeeds:(NSArray *)feeds {
    _feeds = feeds;
    _cview.feeds = _feeds;
}

#pragma mark - View Lifecycle

- (void)loadView {
    [super loadView];
    
    _cview = [[RNStreamView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _cview.delegate = self;
    
    __block typeof(self) s = self;
    _cview.onMenu = ^(RNStreamView *pMenuView) {
        [s onMenuView];
    };
    _cview.onCell = ^(RNStreamView *pMenuView) {
        [s onCell: pMenuView];
    };
    self.view =_cview;
    _cview.feeds = [NSArray arrayWithArray: _feeds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_cview clearFeeds];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_cview appeared: YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if (_bInitialLoad) {
        [_cview loadFeeds];
        _bInitialLoad = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    [_cview appeared: NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Publich Methods

- (void)clearViewsFeeds {
    [_cview clearFeeds];
}

- (void)loadViewFeeds {
    [_cview loadFeeds];
}

#pragma mark - Private Methods

- (void)onMenuView {
    RNStreamVCOnMenu handler = [_handler valueForKey: kBNStreamVCMenuHandlerKey];
    if (handler)
        handler(self);
}

- (void)onCell:(RNStreamView *)pStreamView {
    _articleUrl = pStreamView.articleUrl;
    _articleTitle = pStreamView.articleTitle;
    _articleDesc = pStreamView.articleDesc;
    RNStreamVCOnNews handler = [_handler valueForKey: kBNStreamVCNewsHandlerKey];
    if (handler)
        handler(self);
}

#pragma mark - IBNStreamViewDelegate Methods

- (void)streamViewOnDrag:(CGPoint)pDragPoint {
    [_delegate streamVCOnDrag: pDragPoint];
}

@end
