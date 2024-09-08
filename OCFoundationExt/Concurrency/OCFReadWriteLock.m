//
//  OCFReadWriteLock.m
//  OCFoundationExt
//
//  Created by SuXinDe on 2024/9/8.
//

#import "OCFReadWriteLock.h"
#import <pthread.h>

@interface OCFReadLock : NSObject<OCFLockable> {
    pthread_rwlock_t *rwlock;
}

- (instancetype)initWithLock:(pthread_rwlock_t *)lock;

@end

@implementation OCFReadLock

- (instancetype)initWithLock:(pthread_rwlock_t *)lock {
    if (self = [super init]) {
        rwlock = lock;
    }
    return self;
}

- (void)lock {
    pthread_rwlock_rdlock(self->rwlock);
}

- (void)unlock {
    pthread_rwlock_unlock(self->rwlock);
}

@end

@interface OCFWriteLock : NSObject<OCFLockable>{
    pthread_rwlock_t *rwlock;
}

- (instancetype)initWithLock:(pthread_rwlock_t *)lock;

@end

@implementation OCFWriteLock

- (instancetype)initWithLock:(pthread_rwlock_t *)lock {
    if (self = [super init]) {
        rwlock = lock;
    }
    return self;
}

- (void)lock {
    pthread_rwlock_wrlock(self->rwlock);
}

- (void)unlock {
    pthread_rwlock_unlock(self->rwlock);
}

@end


@interface OCFReadWriteLock () {
    pthread_rwlock_t rwlock;
}

@end

@implementation OCFReadWriteLock

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_rwlock_init(&rwlock, NULL);
    }
    return self;
}

- (id<OCFLockable>)readLock {
    if (!_readLock) {
        _readLock = [[OCFReadLock alloc] initWithLock:&rwlock];
    }
    
    return _readLock;
}

- (id<OCFLockable>)writeLock {
    if (!_writeLock) {
        _writeLock = [[OCFWriteLock alloc] initWithLock:&rwlock];
    }
    
    return _writeLock;
}

@end

