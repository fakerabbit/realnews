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
    return @[@{kRNKeySourceTitle: @"Four Four Two",
               kRNKeySourceUrl: @[@"http://www.fourfourtwo.com/taxonomy/term/159/rss"]},
             @{kRNKeySourceTitle: @"Real Madrid C.F.",
               kRNKeySourceUrl: @[@"http://www.realmadrid.com/cs/Satellite/en/RSS.htm"]},
             @{kRNKeySourceTitle: @"FoxSports",
               kRNKeySourceUrl: @[@"http://api.foxsports.com/v1/rss?partnerKey=zBaFxRyGKCfxBagJG9b8pqLyndmvo7UU&tag=soccer"]},
             @{kRNKeySourceTitle: @"Goal.com",
               kRNKeySourceUrl: @[@"http://goal.com/en-us/feeds/team-news?id=124&fmt=rss"]},
             @{kRNKeySourceTitle: @"Google News",
               kRNKeySourceUrl: @[@"https://news.google.com/news/feeds?q=real+madrid+news&bav=on.2,or.r_cp.r_qf.&bvm=bv.52288139,d.eWU,pv.xjs.s.en_US.nYXFudhZpfw.O&biw=1440&bih=700&dpr=1&um=1&ie=UTF-8&output=rss"]},
             @{kRNKeySourceTitle: @"Tribal Football",
               kRNKeySourceUrl: @[@"http://www.tribalfootball.com/rss/mediafed/general/rss.xml?club=real-madrid"]},
             @{kRNKeySourceTitle: @"MARCA",
               kRNKeySourceUrl: @[@"http://estaticos.marca.com/rss/futbol/real-madrid.xml"]},
             @{kRNKeySourceTitle: @"ESPN FC",
               kRNKeySourceUrl: @[@"http://espnfc.com/blog/rss/_/name/realmadrid"]},
             @{kRNKeySourceTitle: @"CFReal",
               kRNKeySourceUrl: @[@"http://www.cfreal.com/feed/"]},
             @{kRNKeySourceTitle: @"BBC Sport",
               kRNKeySourceUrl: @[@"http://newsrss.bbc.co.uk/rss/sportplayer_uk_edition/football_focus/rss.xml"]},
             @{kRNKeySourceTitle: @"Cristiano Ronaldo",
               kRNKeySourceUrl: @[@"http://www.ronaldoweb.com/seccion/real-madrid/feed/"]},
             @{kRNKeySourceTitle: @"Sky SPORTS",
               kRNKeySourceUrl: @[@"http://www1.skysports.com/feeds/11835/news.xml"]},
             @{kRNKeySourceTitle: @"Football España",
               kRNKeySourceUrl: @[@"http://www.football-espana.net/rss.xml"]},
             @{kRNKeySourceTitle: @"La Liga Talk",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/laligatalk"]},
             @{kRNKeySourceTitle: @"Soccernews",
               kRNKeySourceUrl: @[@"https://feeds.feedburner.com/soccernewsfeed"]},
             @{kRNKeySourceTitle: @"Eye Football",
               kRNKeySourceUrl: @[@"http://www.eyefootball.com/rss_news_main.xml"]},
             @{kRNKeySourceTitle: @"The Guardian",
               kRNKeySourceUrl: @[@"http://www.theguardian.com/football/realmadrid/rss"]},
             @{kRNKeySourceTitle: @"World Soccer",
               kRNKeySourceUrl: @[@"http://www.worldsoccer.com/feed"]},
             @{kRNKeySourceTitle: @"Caught Offside",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/caughtoffside/SXbH"]}
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
    return @[@{kRNKeySourceTitle: @"LaInformación",
               kRNKeySourceUrl: @[@"http://rss.noticias.lainformacion.com/deporte/futbol/"]},
             @{kRNKeySourceTitle: @"AS",
               kRNKeySourceUrl: @[@"http://www.as.com/rss/feed.html?feedId=61"]},
             @{kRNKeySourceTitle: @"Marca",
               kRNKeySourceUrl: @[@"http://estaticos.marca.com/rss/futbol/real-madrid.xml"]},
             @{kRNKeySourceTitle: @"MundoDeportivo",
               kRNKeySourceUrl: @[@"http://feeds.feedburner.com/mundodeportivo-realmadrid"]},
             @{kRNKeySourceTitle: @"Sport",
               kRNKeySourceUrl: @[@"http://www.sport.es/es/rss/liga-bbva/rss.xml"]},
             /*@{kRNKeySourceTitle: @"El Pais",
               kRNKeySourceUrl: @[@"http://elpais.com/tag/rss/liga_espanola_de_futbol/a"]},*/
             @{kRNKeySourceTitle: @"20 Minutos",
               kRNKeySourceUrl: @[@"http://www.20minutos.es/rss/especial/futbol/"]},
             @{kRNKeySourceTitle: @"Fichajes",
               kRNKeySourceUrl: @[@"http://www.diarioinformacion.com/elementosInt/rss/75"]},
             @{kRNKeySourceTitle: @"Superdeporte",
               kRNKeySourceUrl: @[@"http://www.superdeporte.es/elementosInt/rss/3"]},
             @{kRNKeySourceTitle: @"El Periódico",
               kRNKeySourceUrl: @[@"http://www.elperiodico.com/es/rss/galleries/deportes/rss.xml"]},
             @{kRNKeySourceTitle: @"europapress",
               kRNKeySourceUrl: @[@"http://www.europapress.es/rss/rss.aspx?ch=162"]}
             /*@{kRNKeySourceTitle: @"La Vanguardia",
               kRNKeySourceUrl: @[@"http://www.lavanguardia.com/feed/deportes/futbol/index.xml"]}*/
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
    return @[@{kRNKeySourceTitle: @"My Madrid",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=MyMadrid_RM"]},
             @{kRNKeySourceTitle: @"Real Madrid ENG",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=realmadriden"]},
             @{kRNKeySourceTitle: @"Real Madrid",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=realmadrid"]},
             @{kRNKeySourceTitle: @"Real Madrid News",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=RMadridCF_News"]},
             @{kRNKeySourceTitle: @"Marcelo",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=12MarceloV"]},
             @{kRNKeySourceTitle: @"Arbeloa",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=aarbeloa17"]},
             @{kRNKeySourceTitle: @"Xabi Alonso",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=XabiAlonso"]},
             @{kRNKeySourceTitle: @"Morata",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=AlvaroMorata"]},
             @{kRNKeySourceTitle: @"Sergio Ramos",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=SergioRamos"]},
             @{kRNKeySourceTitle: @"Jesús Fernandez",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=JesusFdezCo"]},
             @{kRNKeySourceTitle: @"Nacho Fernandez",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=nachofi1990"]},
             @{kRNKeySourceTitle: @"Varane",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=varaneofficiel"]},
             @{kRNKeySourceTitle: @"Isco",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=isco_alarcon"]},
             @{kRNKeySourceTitle: @"CR7",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=Cristiano"]},
             @{kRNKeySourceTitle: @"Jese Rodriguez",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=JeseRodriguez10"]},
             @{kRNKeySourceTitle: @"Pepe",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=officialpepe"]},
             @{kRNKeySourceTitle: @"La Cantera",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=lafabricacrm"]},
             @{kRNKeySourceTitle: @"Casemiro",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=Casemiro_92"]},
             @{kRNKeySourceTitle: @"Gareth Bale",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=GarethBale11"]},
             @{kRNKeySourceTitle: @"Carvajal",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=DaniCarvajal92"]},
             @{kRNKeySourceTitle: @"Ancelotti",
               kRNKeySourceUrl: @[@"https://script.google.com/macros/s/AKfycbxJp9e0ptg7SYT5WbfXiynCk_OrR6zWPAs1jfSmgLw_EaV44is/exec?action=timeline&q=MrAncelotti"]}
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
