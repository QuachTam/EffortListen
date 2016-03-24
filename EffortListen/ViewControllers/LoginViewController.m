//
//  LoginViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    QBUUser *currentUser = [QBUUser new];
    currentUser.email = @"mr.tamqn87hb@gmail.com";
    currentUser.password = @"Quachtam87";
    [SVProgressHUD showWithStatus:@"Logging in"];
    __weak __typeof(self)weakSelf = self;
    [QMServicesManager.instance logInWithUser:currentUser completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            __typeof(self) strongSelf = weakSelf;
            [self checkDeviceBlock:^(BOOL isBlock) {
                if (!isBlock) {
                    [SVProgressHUD dismiss];
                    [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
                }else{
                    [CommonFeature showAlertTitle:@"EffortListen" Message:@"Your device is blocked" duration:3.0 showIn:self blockDismissView:nil];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

- (void)checkDeviceBlock:(void(^)(BOOL isBlock))success {
    [QBRequest objectsWithClassName:@"BlockDevice" successBlock:^(QBResponse * _Nonnull response, NSArray * _Nullable objects) {
        if (objects.count) {
            QBCOCustomObject *customObject = [objects firstObject];
            if ([self isBlockWithArrayDevice:customObject.fields[@"uuidDevice"]]) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        }else{
            if (success) {
                success(NO);
            }
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success(NO);
        }
    }];
}

- (BOOL)isBlockWithArrayDevice:(NSArray *)arrayBlock {
    BOOL isBlock = NO;
    NSString *currentDevice = [CommonFeature deviceUUID];
    if ([arrayBlock containsObject:currentDevice]) {
        isBlock = YES;
    }
    return isBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
