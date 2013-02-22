//
//  KVServiceContainer.m
//  KVLibrary
//
//  Created by Johan Kool on 15/1/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVServiceContainer.h"
#import "KVServiceContainer-Protected.h"

@interface KVServiceContainer()

@property (nonatomic, retain) NSMutableDictionary *services;

@end

@implementation KVServiceContainer

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.services = [NSMutableDictionary dictionaryWithCapacity:10];
    }

    return self;
}

- (id)serviceForKey:(NSUInteger)serviceKey {
    return [self.services objectForKey:[NSNumber numberWithInt:serviceKey]];
}

- (id)serviceForKey:(NSUInteger)serviceKey initializer:(id (^)(void))initializer {
    @synchronized(self) {
        id service = [self.services objectForKey:[NSNumber numberWithInt:serviceKey]];

        if (service == nil && initializer != nil) {
            service = initializer();

            if (service != nil) {
                [self setService:service forKey:serviceKey];
            }
        }
        return service;
    }
}

- (void)setService:(id)service forKey:(NSUInteger)serviceKey {
    [self.services setObject:service forKey:[NSNumber numberWithInt:serviceKey]];
}

@end