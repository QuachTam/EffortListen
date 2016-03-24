//
//  PlaySound.h
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaySound : NSObject
- (void)showVideoWithFrame:(CGRect)frame;
+ (instancetype)instance;
- (void)playWithURLString:(NSString *)urlString;
- (void)stop;
- (void)play;
- (void)pause;
- (void)dismiss;
@end