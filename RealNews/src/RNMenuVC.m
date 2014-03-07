//
//  RNMenuVC.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNMenuVC.h"

#import "RNKeys.h"

@interface RNMenuVC ()
-(void)onMenuVC;
-(void)onNewsVC;
-(void)clearFeeds;
-(void)closeMenu:(RNMenuView*)pMenuView;
-(void)onSource;

-(NSArray*)getCurrentSource;
-(NSArray*)getAllSources;
-(NSArray*)getSpanishSource;
-(NSArray*)getAllSpanishSources;
-(NSArray*)getTwitterSource;
-(NSArray*)getAllTwitterSources;
@end

@implementation RNMenuVC

NSTimeInterval const kBNMenuVCLeftMenuAnimationDuration  = 0.3;
CGFloat const kBNMenuVCLeftSlideoutMenuPaddingRight      = 38.f;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _bRefresh = NO;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    __block typeof(self) s = self;
    
    _cview = [[RNMenuView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _cview.sourcesArray = [NSArray arrayWithArray: [self getAllSources]];
    _cview.spanishSourcesArray = [NSArray arrayWithArray: [self getAllSpanishSources]];
    _cview.twitterSourcesArray = [NSArray arrayWithArray: [self getAllTwitterSources]];
    _cview.onClearFeeds = ^(RNMenuView *pMenuView) {
        [s clearFeeds];
    };
    _cview.onSource = ^(RNMenuView *pMenuView) {
        [s closeMenu: pMenuView];
    };
    self.view = _cview;
    
    _streamVC = [[RNStreamVC alloc] init];
    _streamVC.delegate = self;
    [_streamVC clearViewsFeeds];
    _streamVC.feeds = [self getCurrentSource];
    [self.view addSubview: _streamVC.view];
    
    _streamVC.onMenu = ^(RNStreamVC *pStreamVC) {
        [s onMenuVC];
    };
    _streamVC.onNews = ^(RNStreamVC *pStreamVC) {
        s.articleUrl = pStreamVC.articleUrl;
        s.articleTitle = pStreamVC.articleTitle;
        s.articleDesc = pStreamVC.articleDesc;
        [s onNewsVC];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_cview selectDefaultSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_streamVC viewDidAppear: animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_streamVC viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)onMenuVC {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat nx = w - kBNMenuVCLeftSlideoutMenuPaddingRight;
    
    if (_streamVC.view.frame.origin.x == nx)
        nx = 0.f;
    
    // Animate navigation controller out of view
    [UIView animateWithDuration: kBNMenuVCLeftMenuAnimationDuration animations: ^() {
        CGFloat ny = _streamVC.view.frame.origin.y;
        CGFloat nw = _streamVC.view.frame.size.width;
        CGFloat nh = _streamVC.view.frame.size.height;
        _streamVC.view.frame = CGRectMake(nx, ny, nw, nh);
    }
                     completion: ^(BOOL finished) {
                         if (finished && _bRefresh)
                             [self onSource];
                     }];
}

- (void)onNewsVC {
    _newsVC = [[RNNewsVC alloc] init];
    _newsVC.articleUrl = _articleUrl;
    _newsVC.articleTitle = _articleTitle;
    _newsVC.articleDesc = _articleDesc;
    __block typeof(self) s = self;
    _newsVC.onBack = ^(RNNewsVC *pNewsVC) {
        [s.navigationController popToRootViewControllerAnimated: YES];
    };
    [self.navigationController pushViewController: _newsVC animated: YES];
}

- (void)clearFeeds {
    [_streamVC clearViewsFeeds];
}

- (void)closeMenu:(RNMenuView *)pMenuView {
    _selectedSection = pMenuView.selectedSection;
    _selectedRow = pMenuView.selectedRow;
    _bRefresh = YES;
    [self onMenuVC];
}

- (void)onSource {
    _bRefresh = NO;
    switch (_selectedSection) {
        case 0:
            _streamVC.feeds = [self getCurrentSource];
            break;
        case 1:
            _streamVC.feeds = [self getSpanishSource];
            break;
        case 2:
            _streamVC.feeds = [self getTwitterSource];
            break;
        default:
            break;
    }
    [_streamVC loadViewFeeds];
}

#pragma mark -

- (NSArray*)getCurrentSource {
    NSArray *allSources = [self getAllSources];
    NSDictionary *currentSource = [allSources objectAtIndex: _selectedRow];
    NSArray *newSource = [NSArray arrayWithArray: [currentSource objectForKey: kRNKeySourceUrl]];
    NSLog(@"******newSource: %@", newSource);
    
    return newSource;
}

- (NSArray*)getAllSources {
    return @[@{kRNKeySourceTitle: @"FoxSports",
               kRNKeySourceUrl: @[@"http://feeds.foxsports.com/feedout/rss/syndicatedContent?categoryId=2818&siteId=20028"]},
             @{kRNKeySourceTitle: @"Goal.com",
               kRNKeySourceUrl: @[@"http://goal.com/en-us/feeds/team-news?id=125&fmt=rss"]},
             @{kRNKeySourceTitle: @"All About FC Barcelona",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/AllAboutFcBarcelona"]},
             @{kRNKeySourceTitle: @"Barcelona Daily",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/barcelonadailynews/tmiv"]},
             @{kRNKeySourceTitle: @"ESPN FC",
               kRNKeySourceUrl: @[@"http://espnfc.com/blog/rss/_/name/barcelona"]},
             @{kRNKeySourceTitle: @"BBC Sport",
               kRNKeySourceUrl: @[@"http://feeds.bbci.co.uk/sport/0/football/rss.xml?edition=int#"]},
             @{kRNKeySourceTitle: @"The Offside",
               kRNKeySourceUrl: @[@"http://feeds.bootsnall.com/theoffside-global"]},
             @{kRNKeySourceTitle: @"Skysports",
               kRNKeySourceUrl: @[@"http://www.skysports.com/rss/0,20514,11827,00.xml"]},
             @{kRNKeySourceTitle: @"TotalBarca",
               kRNKeySourceUrl: @[@"http://www.totalbarca.com/feed/"]},
             @{kRNKeySourceTitle: @"La Liga Talk",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/laligatalk"]},
             @{kRNKeySourceTitle: @"Soccernews",
               kRNKeySourceUrl: @[@"http://www.soccernews.com/category/la-liga/feed"]},
             @{kRNKeySourceTitle: @"Sky Sports",
               kRNKeySourceUrl: @[@"http://www.skysports.com/rss/0,20514,11827,00.xml"]},
             @{kRNKeySourceTitle: @"Eye Football",
               kRNKeySourceUrl: @[@"http://www.eyefootball.com/rss_news_main.xml"]},
             @{kRNKeySourceTitle: @"IBN Live",
               kRNKeySourceUrl: @[@"http://ibnlive.in.com/ibnrss/rss/sports/football.xml"]},
             @{kRNKeySourceTitle: @"The Guardian",
               kRNKeySourceUrl: @[@"http://www.theguardian.com/football/europeanfootball/rss"]},
             @{kRNKeySourceTitle: @"World Soccer",
               kRNKeySourceUrl: @[@"http://www.worldsoccer.com/feed"]},
             @{kRNKeySourceTitle: @"Live Scores",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/rsslivescores/laliga"]}
             ];
}

- (NSArray*)getSpanishSource {
    NSArray *allSources = [self getAllSpanishSources];
    NSDictionary *currentSource = [allSources objectAtIndex: _selectedRow];
    NSArray *newSource = [NSArray arrayWithArray: [currentSource objectForKey: kRNKeySourceUrl]];
    NSLog(@"******newSpanishSource: %@", newSource);
    
    return newSource;
}

- (NSArray*)getAllSpanishSources {
    return @[@{kRNKeySourceTitle: @"LaInformación.com",
               kRNKeySourceUrl: @[@"http://rss.noticias.lainformacion.com/deporte/futbol/"]},
             @{kRNKeySourceTitle: @"AS",
               kRNKeySourceUrl: @[@"http://www.as.com/rss/feed.html?feedId=61"]},
             @{kRNKeySourceTitle: @"Marca",
               kRNKeySourceUrl: @[@"http://estaticos.marca.com/rss/futbol_equipos_barcelona.xml"]},
             @{kRNKeySourceTitle: @"MundoDeportivo",
               kRNKeySourceUrl: @[@"http://www.elmundodeportivo.es/web/rss/titularesbarca.rss"]},
             @{kRNKeySourceTitle: @"Sport",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/sport/barsa"]},
             @{kRNKeySourceTitle: @"El Pais",
               kRNKeySourceUrl: @[@"http://elpais.com/tag/rss/liga_espanola_de_futbol/a"]},
             @{kRNKeySourceTitle: @"20 Minutos",
               kRNKeySourceUrl: @[@"http://www.20minutos.es/rss/especial/futbol/"]},
             @{kRNKeySourceTitle: @"Fichajes",
               kRNKeySourceUrl: @[@"http://www.diarioinformacion.com/elementosInt/rss/75"]},
             @{kRNKeySourceTitle: @"Superdeporte",
               kRNKeySourceUrl: @[@"http://www.superdeporte.es/elementosInt/rss/3"]},
             @{kRNKeySourceTitle: @"El Periódico",
               kRNKeySourceUrl: @[@"http://www.elperiodico.com/es/rss/galleries/deportes/rss.xml"]},
             @{kRNKeySourceTitle: @"europapress",
               kRNKeySourceUrl: @[@"http://www.europapress.es/rss/rss.aspx?ch=162"]},
             @{kRNKeySourceTitle: @"La Vanguardia",
               kRNKeySourceUrl: @[@"http://www.lavanguardia.com/feed/deportes/futbol/index.xml"]},
             @{kRNKeySourceTitle: @"Univision",
               kRNKeySourceUrl: @[@"http://feedsyn.univision.com/futbol/europa"]}
             ];
}

- (NSArray*)getTwitterSource {
    NSArray *allSources = [self getAllTwitterSources];
    NSDictionary *currentSource = [allSources objectAtIndex: _selectedRow];
    NSArray *newSource = [NSArray arrayWithArray: [currentSource objectForKey: kRNKeySourceUrl]];
    NSLog(@"******newTwitterSource: %@", newSource);
    
    return newSource;
}

- (NSArray*)getAllTwitterSources {
    return @[@{kRNKeySourceTitle: @"FC Barcelona",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=FCBarcelona"]},
             @{kRNKeySourceTitle: @"FC Barcelona ESP",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=FCBarcelona_es"]},
             @{kRNKeySourceTitle: @"FC Barcelona CAT",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=FCBarcelona_cat"]},
             @{kRNKeySourceTitle: @"Cesc Fabregas Soler",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=cesc4official"]},
             @{kRNKeySourceTitle: @"Jose Manuel Pinto",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=13_Pinto"]},
             @{kRNKeySourceTitle: @"Javier Mascherano",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=Mascherano"]},
             @{kRNKeySourceTitle: @"Cristian Tello",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=ctello91"]},
             @{kRNKeySourceTitle: @"Marc Muniesa",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=muniesa24"]},
             @{kRNKeySourceTitle: @"Sergi Roberto",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=SergiRoberto10"]},
             @{kRNKeySourceTitle: @"Pedro Rodriguez",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=_Pedro17_"]},
             @{kRNKeySourceTitle: @"Daniel Alves",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=DaniAlvesD2"]},
             @{kRNKeySourceTitle: @"Victor Valdes",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=1victorvaldes"]},
             @{kRNKeySourceTitle: @"Gerard Pique",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=3gerardpique"]},
             @{kRNKeySourceTitle: @"Carles Puyol",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=Carles5puyol"]},
             @{kRNKeySourceTitle: @"Neymar Júnior",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=Njr92"]},
             @{kRNKeySourceTitle: @"Team Messi",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=TeamMessi"]},
             @{kRNKeySourceTitle: @"barcastuff",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=barcastuff"]},
             @{kRNKeySourceTitle: @"CanalBarca",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=CanalBarca"]}
             ];
}

#pragma mark - IBNStreamVCDelegate Methods

- (void)streamVCOnDrag:(CGPoint)pDragPoint {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat nx = w - kBNMenuVCLeftSlideoutMenuPaddingRight;
    CGFloat newX = 0.f;
    
    if (pDragPoint.x > 0) { // MOVE RIGHT
        newX = nx;
    }
    else { // MOVE LEFT
        newX = 0;
    }
    
    
    // Animate navigation controller out of view
    [UIView animateWithDuration: kBNMenuVCLeftMenuAnimationDuration animations: ^() {
        CGFloat ny = _streamVC.view.frame.origin.y;
        CGFloat nw = _streamVC.view.frame.size.width;
        CGFloat nh = _streamVC.view.frame.size.height;
        _streamVC.view.frame = CGRectMake(newX, ny, nw, nh);
    }
                     completion: ^(BOOL finished) {
                         if (finished && _bRefresh)
                             [self onSource];
                         // [_window insertSubview: _tapView aboveSubview: _nav.view];
                     }];
}

@end
