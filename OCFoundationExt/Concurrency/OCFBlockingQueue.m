//
//  OCFBlockingQueue.m
//  OCFoundationExt
//
//  Created by SuXinDe on 2024/9/8.
//

#import "OCFBlockingQueue.h"
#include <pthread.h>
#include <sys/time.h>

@interface OCFBlockingQueue () {
    NSInteger maxSize;
    NSMutableArray *queue;
    pthread_mutex_t lock;
    pthread_cond_t notEmpty, notFull;
}

@end

@implementation OCFBlockingQueue

- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        maxSize = capacity;
        queue = [[NSMutableArray alloc] initWithCapacity: maxSize];
        
        pthread_mutex_init(&lock, NULL);
        pthread_cond_init(&notEmpty, NULL);
        pthread_cond_init(&notFull, NULL);
    }
    return self;
}

- (void)put:(id)data {
    pthread_mutex_lock(&lock);
    
    while ([queue count] == maxSize) {
        pthread_cond_wait(&notFull, &lock);
    }
    [queue addObject: data];
    
    pthread_cond_signal(&notEmpty);
    pthread_mutex_unlock(&lock);
}

- (id)take:(NSInteger)timeout {
    pthread_mutex_lock(&lock);
    
    struct timespec ts;
    struct timeval now;
    
    gettimeofday(&now, NULL);
    ts.tv_sec = now.tv_sec + timeout;
    ts.tv_nsec = 0;
    
    while ([queue count] == 0) {
        if (pthread_cond_timedwait(&notEmpty, &lock, &ts) != 0) {
            pthread_mutex_unlock(&lock);
            return nil;
        }
    }
    
    id data = [queue objectAtIndex:0];
    [queue removeObjectAtIndex:0];
    
    pthread_cond_signal(&notFull);
    pthread_mutex_unlock(&lock);
    
    return data;
}

- (id)take {
    return [self take:INT_MAX];
}

- (void)clear {
    [queue removeAllObjects];
}

- (void)dealloc {
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&notEmpty);
    pthread_cond_destroy(&notFull);
}

@end
