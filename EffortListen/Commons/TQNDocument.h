//
//  TQNDocument.h
//  EffortListen
//
//  Created by Tamqn on 3/25/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQNDocument : NSObject
+ (instancetype)instance;
- (NSString *)getDocumentsPath;
@end
