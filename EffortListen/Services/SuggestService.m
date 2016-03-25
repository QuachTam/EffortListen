//
//  SuggestService.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SuggestService.h"

@implementation SuggestService
+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}
- (void)sendSuggestBook:(NSString *)bookName bookType:(NSString*)bookType linkDownload:(NSString*)linkDownload success:(void(^)(BOOL isSuccess))success{
    QBCOCustomObject *customObject = [QBCOCustomObject new];
    customObject.className = @"Suggest";
    customObject.fields[@"bookName"] = bookName;
    customObject.fields[@"bookType"] = bookType;
    customObject.fields[@"linkDownload"] = linkDownload;
    customObject.fields[@"uuidDevice"] = [CommonFeature deviceUUID];
    [QBRequest createObject:customObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
        if (success) {
            success(YES);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success(NO);
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


@end
