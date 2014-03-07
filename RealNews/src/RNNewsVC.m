//
//  RNNewsVC.m
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import "RNNewsVC.h"

#import <Social/Social.h>

@interface RNNewsVC ()
-(void)onBackButton;

-(void)onEmail;
-(void)onFacebook;
-(void)onTwitter;
@end

@implementation RNNewsVC

NSString * const kBNNewsVCBackHandlerKey = @"news vc back handler";

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _handler = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Setup

- (void)setOnBack:(RNNewsVCOnBack)onBack {
    [_handler setValue: [onBack copy] forKey: kBNNewsVCBackHandlerKey];
}

#pragma mark - View Lifecycle

- (void)loadView {
    [super loadView];
    
    _cview = [[RNNewsView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _cview.articleUrl = _articleUrl;
    
    __block typeof(self) s = self;
    _cview.onBack = ^(RNNewsView *pNewsView) {
        [s onBackButton];
    };
    _cview.onEmail = ^(RNNewsView *pNewsView) {
        [s onEmail];
    };
    _cview.onFacebook = ^(RNNewsView *pNewsView) {
        [s onFacebook];
    };
    _cview.onTwitter = ^(RNNewsView *pNewsView) {
        [s onTwitter];
    };
    self.view = _cview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)onBackButton {
    RNNewsVCOnBack handler = [_handler valueForKey: kBNNewsVCBackHandlerKey];
    if (handler)
        handler(self);
}

- (void)onEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Madrid News"];
        
        // Fill out the email body text
        NSString* title1 = [NSString stringWithFormat: @"\n<h2>%@:</h2>\n", _articleTitle];
        NSString* content1 = _articleDesc;
        NSString* pageLink = [NSString stringWithFormat: @"<p><br/>%@</p><br/>", _articleUrl];
        NSString* iTunesLink = [NSString stringWithFormat: @"<a href=\"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=329937374&mt=8\">Barcelona News</a>"]; // replate it with App's link
        NSString* emailBody =
        [NSString stringWithFormat:@"%@ %@ %@ %@", title1, content1, pageLink, iTunesLink];
        
        [mailer setMessageBody: emailBody isHTML: YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
        
        mailer.navigationBar.barStyle = UIBarStyleDefault;
        
        [self presentViewController: mailer animated: YES completion:^(void){
            NSLog(@"mailer...");
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Failure"
                                                        message: @"Your device doesn't support the email composer sheet"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)onFacebook {
    if([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
        SLComposeViewController *socialView = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Facebook Result: canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Facebook Result: sent");
                    break;
                default:
                    NSLog(@"Facebook Result: default");
                    break;
            }
            
            [self dismissViewControllerAnimated: YES completion: nil];
        };
        
        socialView.completionHandler = myBlock;
        [socialView setInitialText: @"#MadridNews for iPhone"];
        [socialView addURL: [NSURL URLWithString: _articleUrl]];
        [self presentViewController: socialView animated: YES completion: nil];
    }
}

- (void)onTwitter {
    if([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]) {
        SLComposeViewController *socialView = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Twitter Result: canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Twitter Result: sent");
                    break;
                default:
                    NSLog(@"Twitter Result: default");
                    break;
            }
            
            [self dismissViewControllerAnimated: YES completion: nil];
        };
        
        socialView.completionHandler = myBlock;
        [socialView setInitialText: @"#RMadridNews"];
        [socialView addURL: [NSURL URLWithString: _articleUrl]];
        [self presentViewController: socialView animated: YES completion: nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated: YES completion: ^(void){
        NSLog(@"dismiss mailer...");
    }];
}

@end
