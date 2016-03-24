//
//  SuggestViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SuggestViewController.h"
#import "SuggestService.h"

@interface SuggestViewController ()

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Suggest Book PDF";
    self.sendButton.layer.cornerRadius = 4.0;
    self.sendButton.layer.masksToBounds = YES;
    
    self.viewSuggest.layer.cornerRadius = 4.0;
    self.viewSuggest.layer.masksToBounds = YES;
}

- (BOOL)isBookNameTextField {
    return (self.bookNameTextField.text.length>0 && self.bookNameTextField.text !=nil);
}

- (BOOL)isBookTypeTextField {
    return (self.bookTypeTextField.text.length>0 && self.bookTypeTextField.text !=nil);
}

- (BOOL)isLinkDownloadTextField {
    return (self.linkDownloadTextField.text.length>0 && self.linkDownloadTextField.text !=nil);
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

- (IBAction)sendAction:(id)sender {
    BOOL isValid = YES;
    if (![self isBookNameTextField]) {
        isValid = NO;
        self.bookNameTextField.backgroundColor = [UIColor redColor];
    }else{
        self.bookNameTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self isBookTypeTextField]) {
        isValid = NO;
        self.bookTypeTextField.backgroundColor = [UIColor redColor];
    }else{
        self.bookTypeTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self isLinkDownloadTextField]) {
        isValid = NO;
        self.linkDownloadTextField.backgroundColor = [UIColor redColor];
    }else{
        self.linkDownloadTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (isValid) {
        SuggestService *service = [SuggestService instance];
        [service sendSuggestBook:self.bookNameTextField.text bookType:self.bookTypeTextField.text linkDownload:self.linkDownloadTextField.text success:^(BOOL isSuccess) {
            [CommonFeature showAlertTitle:@"EffortListen" Message:@"Thanks your send suggest" duration:2.0 showIn:self blockDismissView:nil];
        }];
    }
}
@end
