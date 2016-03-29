//
//  PlaySound.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "PlaySound.h"
#import <KRVideoPlayerController.h>

@interface PlaySound()
@property (strong, nonatomic) KRVideoPlayerController *videoController;
@end

@implementation PlaySound
+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (void)showVideoWithFrame:(CGRect)frame{
    __weak typeof(self)weakSelf = self;
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
}

- (void)playWithURLString:(NSString *)urlString {
    self.videoController.contentURL = [NSURL URLWithString:urlString];
}

- (void)stop {
    if (self.videoController) {
        [self.videoController stop];
    }
}

- (void)play {
    if (self.videoController) {
        [self.videoController play];
    }
}

- (void)pause {
    if (self.videoController) {
        [self.videoController pause];
    }
}

- (void)dismiss{
    if (self.videoController) {
        [self.videoController dismiss];
    }
}

@end
