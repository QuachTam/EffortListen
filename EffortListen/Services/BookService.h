//
//  BookService.h
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookService : NSObject
@property (nonatomic, readwrite, copy) void(^didCompleteFetchBlob)(NSArray *blobs);
+ (instancetype)instance;
- (void)getListBlobWithID:(NSArray *)arrayID;
@end
