//
//  AdmodManager.m
//  QuickBlox
//
//  Created by Tamqn on 3/10/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
@class GADBannerView;
@import GoogleMobileAds;

static NSString *ClientAppID = @"ca-app-pub-9259023205127043/7494555614";

#import "AdmodManager.h"
#import <PureLayout/PureLayout.h>


@interface AdmodManager ()<GADInterstitialDelegate>
/// The DFP interstitial ad.
@property(nonatomic, strong) DFPInterstitial *interstitial;
@end

@implementation AdmodManager

+ (AdmodManager*)sharedInstance {
    static AdmodManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AdmodManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showAdmodInTop {
    
}

- (void)showAdmodInTopThisViewController:(UIViewController *)controller {
    UIView *viewBannerAdMod = [[UIView alloc] initForAutoLayout];
    GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = ClientAppID;
    bannerView_.rootViewController = controller;
    bannerView_.autoloadEnabled = YES;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [bannerView_ loadRequest:request];
    [viewBannerAdMod addSubview:bannerView_];
    [controller.view insertSubview:viewBannerAdMod atIndex:0];
    
    [viewBannerAdMod autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [viewBannerAdMod autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [viewBannerAdMod autoSetDimension:ALDimensionHeight toSize:kGADAdSizeBanner.size.height];
    [viewBannerAdMod autoSetDimension:ALDimensionWidth toSize:controller.view.frame.size.width];
}


NSInteger typeTop = 0;

- (void)showAdmodInViewController:(NSInteger)number{
    UIViewController *root = [self getCurrentViewController];
    UIView *viewBannerAdMod = [[UIView alloc] initForAutoLayout];
    GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = ClientAppID;
    bannerView_.rootViewController = root;
    bannerView_.autoloadEnabled = YES;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [bannerView_ loadRequest:request];
    [viewBannerAdMod addSubview:bannerView_];
    [root.view addSubview:viewBannerAdMod];
    
    [viewBannerAdMod autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [viewBannerAdMod autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [viewBannerAdMod autoSetDimension:ALDimensionHeight toSize:kGADAdSizeBanner.size.height];
    [viewBannerAdMod autoSetDimension:ALDimensionWidth toSize:root.view.frame.size.width];
}

#pragma mark getCurrentViewController
- (id)getCurrentViewController {
    id WindowRootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    id currentViewController = [self findTopViewController:WindowRootVC];
    return currentViewController;
}

- (id)findTopViewController:(id)inController {
    if ([inController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[inController selectedViewController]];
    } else if ([inController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[inController visibleViewController]];
    } else if ([inController isKindOfClass:[UIViewController class]]) {
        return inController;
    } else {
        NSLog(@"Unhandled ViewController class : %@",inController);
        return nil;
    }
}

#pragma mark createAndLoadInterstitial
- (void)createAndLoadInterstitial {
    self.interstitial = [[DFPInterstitial alloc] initWithAdUnitID:ClientAppID];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [self.interstitial loadRequest:request];
}

#pragma mark GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self.interstitial presentFromRootViewController:[self getCurrentViewController]];
}

- (void)interstitial:(DFPInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(DFPInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    if (self.interstitialDidDismissScreen) {
        self.interstitialDidDismissScreen();
    }
}

@end
