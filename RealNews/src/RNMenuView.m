//
//  RNMenuView.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNMenuView.h"

#import "RNImages.h"
#import "RNKeys.h"
#import "RNMenuCell.h"
#import "RNMenuHeader.h"

@implementation RNMenuView

NSString * const kBNMenuViewSourceHandlerKey     = @"menu view source handler";
NSString * const kBNMenuViewClearFeedsHandlerKey = @"menu view clear feeds handler";

#define kBNMenuViewMenuHeaderH 50.f

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: kRNImageDrkBlueTile]];
        _selectedRow = 0;
        _selectedSection = 0;
        _handler = [NSMutableDictionary dictionary];
        
        _logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: kRNImageLogo]];
        [self addSubview: _logo];
        
        _sourcesTv = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStyleGrouped];
        _sourcesTv.delegate = self;
        _sourcesTv.dataSource = self;
        _sourcesTv.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview: _sourcesTv];
        _sourcesTv.backgroundColor = [UIColor clearColor]; //[UIColor colorWithPatternImage:[UIImage imageNamed: kBNImageDrkBlueTile]];
        
        // Create the shadow
        UIImage *shadowImg2 = [UIImage imageNamed: kRNImageSourcesShadow];
        shadowImg2 = [shadowImg2 resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg2.size.height/2.f, 0.f, shadowImg2.size.height/2.f, 0.f)];
        _titleShadowIv = [[UIImageView alloc] initWithImage: shadowImg2];
        [self addSubview: _titleShadowIv];
    }
    return self;
}

#pragma mark - Setup

- (void)setOnSource:(RNMenuViewOnSource)onSource {
    [_handler setValue: [onSource copy] forKey: kBNMenuViewSourceHandlerKey];
}

- (void)setOnClearFeeds:(RNMenuViewOnClearFeeds)onClearFeeds {
    [_handler setValue: [onClearFeeds copy] forKey: kBNMenuViewClearFeedsHandlerKey];
}

#pragma mark - Public Methods

- (void)selectDefaultSource {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: _selectedRow inSection: _selectedSection];
    [_sourcesTv selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionTop];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _logo.frame = CGRectMake(-10.f, 10.f, _logo.frame.size.width, _logo.frame.size.height);
    _titleShadowIv.frame = CGRectMake(0.f, _logo.frame.origin.y + _logo.frame.size.height, w, _titleShadowIv.frame.size.height);
    _sourcesTv.frame = CGRectMake(0.f, _logo.frame.origin.y + _logo.frame.size.height, w, h - _logo.frame.size.height - _logo.frame.origin.y);
}

#pragma mark -
#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows = 0;
    
    switch (section) {
        case 0:
            rows = [_sourcesArray count];
            break;
        case 1:
            rows = [_spanishSourcesArray count];
            break;
        case 2:
            rows = [_twitterSourcesArray count];
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NSString *cellIdentifier = @"RNMenuViewCellIdentifier";
    
    RNMenuCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (!cell) {
        cell = [[RNMenuCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    
    switch (section) {
        case 0:
            cell.title = [[_sourcesArray objectAtIndex: row] objectForKey: kRNKeySourceTitle];
            break;
        case 1:
            cell.title = [[_spanishSourcesArray objectAtIndex: row] objectForKey: kRNKeySourceTitle];
            break;
        case 2:
            cell.title = [[_twitterSourcesArray objectAtIndex: row] objectForKey: kRNKeySourceTitle];
            break;
        default:
            break;
    }
    
    if (_selectedSection == section && _selectedRow == row) {
        cell.selected = YES;
    }
    else
        cell.selected = NO;
    
    return cell;
}

#pragma mark -

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kBNMenuViewMenuHeaderH;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RNMenuHeader *headerView = [[RNMenuHeader alloc] initWithFrame: CGRectMake(0.f, 0.f, tableView.frame.size.width, kBNMenuViewMenuHeaderH)];
    
    switch (section) {
        case 0:
            headerView.title = @"English Sources";
            break;
        case 1:
            headerView.title = @"Fuentes en Español";
            break;
        case 2:
            headerView.title = @"Twitter";
            break;
        default:
            break;
    }
    
    return headerView;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedSection = indexPath.section;
    _selectedRow = indexPath.row;
    
    // Clear Feeds on Sources view
    RNMenuViewOnClearFeeds handler1 = [_handler valueForKey: kBNMenuViewClearFeedsHandlerKey];
    if (handler1)
        handler1(self);
    
    // Close Menu and load new sources
    RNMenuViewOnSource handler = [_handler valueForKey: kBNMenuViewSourceHandlerKey];
    if (handler)
        handler(self);
}

@end
