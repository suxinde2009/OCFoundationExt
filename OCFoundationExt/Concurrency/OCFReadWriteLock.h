//
//  OCFReadWriteLock.h
//  OCFoundationExt
//
//  Created by SuXinDe on 2024/9/8.
//

#import <Foundation/Foundation.h>

#include <pthread.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCFLockable <NSObject>
@required
- (void)lock;
- (void)unlock;
@end

@interface OCFReadWriteLock : NSObject

@property (nonatomic, strong) id<OCFLockable> readLock;

@property (nonatomic, strong) id<OCFLockable> writeLock;

@end

NS_ASSUME_NONNULL_END
