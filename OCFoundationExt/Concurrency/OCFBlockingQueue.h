//
//  OCFBlockingQueue.h
//  OCFoundationExt
//
//  Created by SuXinDe on 2024/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCFBlockingQueue : NSObject

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (void)put:(id)data;

- (id)take:(NSInteger)timeout;

- (id)take;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
