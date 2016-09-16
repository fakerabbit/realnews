//
//  RNStreamView.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNStreamView.h"

#import "RNImages.h"
#import "RNTheme.h"
#import "RNStreamViewCell.h"
#import "RSSAtomKit.h"
#import "RSSPerson.h"

@interface RNStreamView (Private)
-(void)onMenuButton;
-(void)onRefreshControl;
-(void)refreshFeeds;
-(void)onDragView:(UIPanGestureRecognizer*)pGesture;

-(BOOL)parseURL:(NSString*)sURL;
-(void) traverseElement:(TBXMLElement *)element;
-(NSString*)checkURL:(NSString*)htmlString;
-(NSString*)textToHtml:(NSString*)htmlString;
@end

@implementation RNStreamView

@synthesize delegate = _delegate;

NSString * const kBNStreamViewMenuHandlerKey = @"stream view menu handler";
NSString * const kBNStreamViewCellHandlerKey = @"stream view cell handler";
NSString * const kBNStreamViewMenuCell       = @"StreamView CV Cell";

#define kBNStreamViewMenuBtnLeftPad 5.f
#define kBNStreamViewMenuBtnTopPad 20.f
#define kBNStreamViewMenuShadowLeftPad 5.f
#define kBNStreamViewMenuCVItemHeight 50.f
#define kBNStreamViewMenuCVItemPad 10.f

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _handler = [NSMutableDictionary dictionary];
        _allEntries = [NSMutableArray array];
        _articleUrl = nil;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(onDragView:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer: panGestureRecognizer];
        
        // Create the feeds collection view
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        [flow setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, kBNStreamViewMenuCVItemHeight)];
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        flow.headerReferenceSize = CGSizeMake(0, 10.f);
        _feedsCv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: flow];
        _feedsCv.delegate = self;
        _feedsCv.dataSource = self;
        _feedsCv.backgroundColor = [UIColor whiteColor];
        [_feedsCv registerClass: [RNStreamViewCell class] forCellWithReuseIdentifier: kBNStreamViewMenuCell];
        [self addSubview: _feedsCv];
        
        // Create the refresh control
        _refreshCtrl = [[UIRefreshControl alloc] init];
        _refreshCtrl.tintColor = [UIColor grayColor];
        [_refreshCtrl addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        [_feedsCv addSubview: _refreshCtrl];
        _feedsCv.alwaysBounceVertical = YES;
        
        // Create the shadows
        UIImage *shadowImg = [UIImage imageNamed: kRNImageStreamLeftShadow];
        shadowImg = [shadowImg resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg.size.height/2.f, 0.f, shadowImg.size.height/2.f, 0.f)];
        _leftShadowIv = [[UIImageView alloc] initWithImage: shadowImg];
        [self addSubview: _leftShadowIv];
        
        UIImage *shadowImg2 = [UIImage imageNamed: kRNImageStreamTitleShadow];
        shadowImg2 = [shadowImg2 resizableImageWithCapInsets: UIEdgeInsetsMake(shadowImg2.size.height/2.f, 0.f, shadowImg2.size.height/2.f, 0.f)];
        _titleShadowIv = [[UIImageView alloc] initWithImage: shadowImg2];
        [self addSubview: _titleShadowIv];
        
        // Create menu button
        UIImage *btnImage = [UIImage imageNamed: kRNImageMenuBtn];
        btnImage = [btnImage resizableImageWithCapInsets: UIEdgeInsetsMake(0, btnImage.size.width/2.f, 0, btnImage.size.width/2.f)];
        _menuBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_menuBtn setBackgroundImage: btnImage forState: UIControlStateNormal];
        [_menuBtn addTarget:self action: @selector(onMenuButton) forControlEvents:UIControlEventTouchUpInside];
        [_menuBtn sizeToFit];
        [self addSubview: _menuBtn];
        
        // Create title label
        _titleLbl = [[UILabel alloc] initWithFrame: CGRectZero];
        [_titleLbl setFont: [UIFont fontWithName: kRNThemeFontHelveticaNeue size: 24.f]];
        [_titleLbl setTextColor: [UIColor blackColor]];
        [_titleLbl setText: @"Madrid News"];
        [_titleLbl sizeToFit];
        [self addSubview: _titleLbl];
    }
    return self;
}

#pragma mark - Setup

- (void)setOnMenu:(RNStreamViewOnMenu)onMenu {
    [_handler setValue: [onMenu copy] forKey: kBNStreamViewMenuHandlerKey];
}

- (void)setOnCell:(RNStreamViewOnCell)onCell {
    [_handler setValue: [onCell copy] forKey: kBNStreamViewCellHandlerKey];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _leftShadowIv.frame = CGRectMake(-_leftShadowIv.frame.size.width, 0.f, _leftShadowIv.frame.size.width, h);
    _menuBtn.frame = CGRectMake(kBNStreamViewMenuBtnLeftPad, kBNStreamViewMenuBtnTopPad, _menuBtn.frame.size.width, _menuBtn.frame.size.height);
    _titleLbl.frame = CGRectMake(w/2.f - _titleLbl.frame.size.width/2.f, kBNStreamViewMenuBtnTopPad, _titleLbl.frame.size.width, _titleLbl.frame.size.height);
    _titleShadowIv.frame = CGRectMake(0.f, _titleLbl.frame.origin.y + _titleLbl.frame.size.height + 5.f, w, _titleShadowIv.frame.size.height);
    _feedsCv.frame = CGRectMake(0.f, _titleShadowIv.frame.origin.y, w, h - _titleShadowIv.frame.origin.y);
}

#pragma mark - Public Methods

- (void)clearFeeds {
    [_allEntries removeAllObjects];
    _allEntries = [NSMutableArray array];
    [_feedsCv reloadData];
    [_refreshCtrl beginRefreshing];
}

- (void)loadFeeds {
    [self refreshFeeds];
    [_refreshCtrl endRefreshing];
    [_feedsCv reloadData];
}

- (void)appeared:(BOOL)pVisible {
    _titleLbl.hidden = !pVisible;
}

#pragma mark - Private Methods

- (void)onMenuButton {
    
    RNStreamViewOnMenu handler = [_handler valueForKey: kBNStreamViewMenuHandlerKey];
    if (handler)
        handler(self);
}

- (void)onRefreshControl {
    [self refreshFeeds];
    [_refreshCtrl endRefreshing];
    [_feedsCv reloadData];
}

- (void)refreshFeeds {
    [_allEntries removeAllObjects];
    _allEntries = [NSMutableArray array];
    BOOL result = NO;
    for (NSString *feed in _feeds) {
        NSLog(@"parse url: %@", feed);
        result = [self parseURL: feed];
    }
    
    if (!result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                        message: @"Unable to fetch news feeds. Check your internet connection."
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Gesture Recognizer

- (void)onDragView:(UIPanGestureRecognizer *)pGesture {
    if ((pGesture.state == UIGestureRecognizerStateChanged) ||
        (pGesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translatedPoint = [pGesture translationInView: self];
        [_delegate streamViewOnDrag: translatedPoint];
    }
}

#pragma mark -
#pragma mark TBXML Parser

- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&amp;"  withString: @"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&lt;"  withString: @"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&gt;"  withString: @">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&quot;" withString: @""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&#039;"  withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&#8217;"  withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&#8211;"  withString: @"-"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&#8220;"  withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"&#8221;"  withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ãº" withString: @"ú"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã³" withString: @"ó"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã©" withString: @"é"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã¡" withString: @"á"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã±" withString: @"ñ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã§" withString: @"ç"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Â£" withString: @"£"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã£" withString: @"ã"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Â´" withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"â" withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Â¿" withString: @"¿"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"â" withString: @"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"Ã" withString: @"í"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
	
    return htmlString;
}

- (NSString*)checkURL:(NSString*)htmlString {
	NSArray* array = [htmlString componentsSeparatedByString: @", "];
	htmlString = [array objectAtIndex:0];
	
    return htmlString;
}


- (void) traverseElement:(TBXMLElement *)element {
	do {
		if ([[TBXML elementName:element] isEqualToString: @"item"]) {
			// Display the name of the element
			NSLog(@"%@",[TBXML elementName:element]);
			
			// if the element has child elements, process them
			if (element->firstChild) {
				_currentItem = [NSMutableDictionary dictionary];
				[_currentItem setObject: [NSMutableString string] forKey: @"title"];
				[_currentItem setObject: [NSMutableString string] forKey: @"link"];
				[_currentItem setObject: [NSMutableString string] forKey: @"description"];
				[_currentItem setObject: [NSMutableString string] forKey: @"pubDate"];
                [_currentItem setObject: [NSMutableString string] forKey: @"author"];
                [_currentItem setObject: [NSMutableString string] forKey: @"enclosure"];
				
				[self traverseElement: element->firstChild];
				
                NSLog(@"_currentItem: %@", _currentItem);
				[_allEntries addObject: _currentItem];
				
				_currentItem = nil;
				_currentElement = nil;
			}
		}
		else if ([[TBXML elementName: element] isEqualToString: @"title"]) {
			// Display the name of the element
			NSString* name = [TBXML textForElement: element];
            NSLog(@"***** name: %@", name);
            name = [self textToHtml: name];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"title"] appendString: name];
		}
		else if ([[TBXML elementName:element] isEqualToString: @"link"]) {
			// Display the name of the element
			NSString* name = [self textToHtml: [TBXML textForElement: element]];
			name = [self checkURL: name];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"link"] appendString: name];
		}
		else if ([[TBXML elementName: element] isEqualToString: @"description"]) {
			// Display the name of the element
			NSString* name = [self textToHtml: [TBXML textForElement: element]];
            name = [self textToHtml: name];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"description"] appendString: name];
		}
		else if ([[TBXML elementName: element] isEqualToString: @"pubDate"]) {
			// Display the name of the element
			NSString* name = [TBXML textForElement: element];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"pubDate"] appendString: name];
		}
        else if ([[TBXML elementName: element] isEqualToString: @"author"]) {
			// Display the name of the element
			NSString* name = [TBXML textForElement: element];
            name = [self textToHtml: name];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"author"] appendString: name];
		}
        else if ([[TBXML elementName: element] isEqualToString: @"enclosure"]) {
			// Display the name of the element
			NSString* name = [TBXML valueOfAttributeNamed: @"url" forElement: element];
            NSLog(@"%@: %@",[TBXML elementName:element], name);
			
			if (_currentItem && name)
				[[_currentItem objectForKey: @"enclosure"] appendString: name];
		}
		else {
            NSLog(@"unknown element: %@", [TBXML elementName: element]);
			if (element->firstChild)
				[self traverseElement: element->firstChild];
		}
		
		// Obtain next sibling element
	} while ((element = element->nextSibling));
}

- (BOOL)parseURL:(NSString*)sURL {
    BOOL result = YES;
    __block BOOL wr = result;
	// Load and parse an xml string
	/*_tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:sURL]];
	
	// If TBXML found a root node, process element and iterate all children
	if (_tbxml.rootXMLElement) {
		[self traverseElement: _tbxml.rootXMLElement];
    }
    else
        result = NO;*/
    dispatch_queue_t reloadQueue = dispatch_queue_create("com.RealNews.timerQueue", DISPATCH_QUEUE_SERIAL);
    RSSAtomKit *atomKit = [[RSSAtomKit alloc] initWithSessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURL *nytimesURL = [NSURL URLWithString: sURL];
    [atomKit parseFeedFromURL:nytimesURL completionBlock:^(RSSFeed *feed, NSArray *items, NSError *error) {
        if (error) {
            NSLog(@"Error for %@: %@", nytimesURL, error);
            wr = NO;
        }
        //NSLog(@"feed: %@ items: %@", feed, items);
        for (int i=0; i<[items count]; i++) {
            RSSItem * item = [items objectAtIndex:i];
            _currentItem = [NSMutableDictionary dictionary];
            [_currentItem setObject: [NSMutableString string] forKey: @"title"];
            [_currentItem setObject: [NSMutableString string] forKey: @"link"];
            [_currentItem setObject: [NSMutableString string] forKey: @"description"];
            [_currentItem setObject: [NSMutableString string] forKey: @"pubDate"];
            [_currentItem setObject: [NSMutableString string] forKey: @"author"];
            [_currentItem setObject: [NSMutableString string] forKey: @"enclosure"];
            
            RSSPerson * author = item.author;
            
            [[_currentItem objectForKey: @"title"] appendString: item.title == nil ? @"title" : item.title];
            [[_currentItem objectForKey: @"link"] appendString: item.linkURL == nil ? @"url" : item.linkURL.absoluteString];
            [[_currentItem objectForKey: @"description"] appendString: item.itemDescription == nil ? @"description" : item.itemDescription];
            [[_currentItem objectForKey: @"pubDate"] appendString: item.publicationDate == nil ? @"date" : [NSDateFormatter localizedStringFromDate:item.publicationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle]];
            [[_currentItem objectForKey: @"author"] appendString: author.name == nil ? @"Anonymous" : author.name];
            [[_currentItem objectForKey: @"enclosure"] appendString: @""];
            
            [_allEntries addObject: _currentItem];
            
            _currentItem = nil;
            _currentElement = nil;
        }
        [_feedsCv reloadData];
    } completionQueue: nil];
    
    return result;
}

#pragma mark
#pragma mark - UICollectionViewDatasource Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section { //Columns
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView { //Rows
    return  [_allEntries count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RNStreamViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier: kBNStreamViewMenuCell forIndexPath: indexPath];
    
    NSUInteger row = [indexPath section];
    NSString *imgUrl = [[_allEntries objectAtIndex: row] objectForKey: @"enclosure"];
    
    if (!imgUrl || [imgUrl isEqualToString: @""])
        [cell setLocalImg: YES];
    else
        [cell setImgUrl: [NSURL URLWithString: imgUrl]];
    
    [cell setDateTime: [[_allEntries objectAtIndex: row] objectForKey: @"pubDate"]];
    [cell setSource: [[_allEntries objectAtIndex: row] objectForKey: @"author"]];
    [cell setTitle: [[_allEntries objectAtIndex: row] objectForKey: @"title"]];
    [cell setDesc: [[_allEntries objectAtIndex: row] objectForKey: @"description"]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _articleUrl = [[_allEntries objectAtIndex: indexPath.section] objectForKey: @"link"];
    //NSLog(@"articleUrl: %@", _articleUrl);
    _articleTitle = [[_allEntries objectAtIndex: indexPath.section] objectForKey: @"title"];
    _articleDesc = [[_allEntries objectAtIndex: indexPath.section] objectForKey: @"description"];
    
    RNStreamViewOnCell handler = [_handler valueForKey: kBNStreamViewCellHandlerKey];
    if (handler)
        handler(self);
}

#pragma mark – UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = self.frame.size.width;
    CGSize size = CGSizeMake(w, 200);
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, kBNStreamViewMenuCVItemPad, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

@end
