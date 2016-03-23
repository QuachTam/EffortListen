//
//  PlaySoundViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "PlaySoundViewController.h"
#import <KRVideoPlayerController.h>

@interface PlaySoundViewController ()
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation PlaySoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 66, width, width*(9.0/16.0))];
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
        weakSelf.videoController = nil;
    }];
    [self.videoController showInWindow];
    self.videoController.contentURL = [NSURL URLWithString:[self.arrayURL objectAtIndex:self.currentIndexURL]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackDidFinishNotification) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)onMPMoviePlayerPlaybackDidFinishNotification{
    self.currentIndexURL++;
    if (self.currentIndexURL<self.arrayURL.count) {
        self.videoController.contentURL = [NSURL URLWithString:[self.arrayURL objectAtIndex:self.currentIndexURL]];
    }
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
