//
//  SettingViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/25/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backButton];
    AdmodManager *adManager = [AdmodManager sharedInstance];
    [adManager showAdmodInViewController];
}

- (void)backButton {
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 25, 25)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
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
