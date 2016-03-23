//
//  BookService.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "BookService.h"

@interface BookService ()
@property (nonatomic, strong) NSMutableArray *arrayBlobs;
@property (nonatomic, strong) NSMutableArray *arrayIDs;
@property (nonatomic, readwrite) BOOL isPending;
@end

@implementation BookService

+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arrayIDs = [NSMutableArray new];
        self.arrayBlobs = [NSMutableArray new];
        self.isPending = NO;
    }
    return self;
}

- (void)getListBlobWithID:(NSArray *)arrayID {
    if (!self.isPending) {
        [self.arrayIDs removeAllObjects];
        [self.arrayBlobs removeAllObjects];
        self.arrayIDs = [NSMutableArray arrayWithArray:arrayID];
        [self startRequest];
    }
}

- (void)startRequest {
    if (self.arrayIDs.count) {
        [self requestBlobWithID:[self getFirstID] success:^(QBCBlob *blob) {
            [self.arrayBlobs addObject:blob];
            [self startRequest];
        }];
    }else{
        self.isPending = NO;
        if (self.didCompleteFetchBlob) {
            self.didCompleteFetchBlob([self.arrayBlobs copy]);
        }
    }
}

- (void)requestBlobWithID:(NSInteger)ID success:(void(^)(QBCBlob *blob))success {
    [QBRequest blobWithID:ID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
        [self removeFirstID];
        if (success) {
            success (blob);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success (nil);
        }
    }];
}

- (NSInteger)getFirstID {
    if (self.arrayIDs.count) {
        return [[self.arrayIDs objectAtIndex:0] integerValue];
    }else{
        return -1;
    }
}

- (void)removeFirstID {
    if (self.arrayIDs.count) {
        [self.arrayIDs removeObjectAtIndex:0];
    }
}
@end
