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
            [SVProgressHUD dismiss];
            [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
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
