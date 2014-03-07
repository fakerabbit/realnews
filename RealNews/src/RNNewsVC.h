//
//  RNNewsVC.h
//  RealNews
//
//  Created by Mirko Justiniano on 9/18/13.
//  Copyright (c) 2013 Mirko Justiniano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "RNNewsView.h"

@interface RNNewsVC : UIViewController <MFMailComposeViewControllerDelegate> {
@private
    RNNewsView *_cview;
    
    NSMutableDictionary *_handler;
}

typedef void (^RNNewsVCOnBack)(RNNewsVC*);
@property (nonatomic, copy) RNNewsVCOnBack onBack;
@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleDesc;

@end
