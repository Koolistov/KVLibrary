//
//  KVAPIPrivate.h
//  KVLibrary
//
//  Created by Johan Kool on 8/6/13.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#ifndef KVAPIPrivate_h
#define KVAPIPrivate_h

#import "KVAPIClient.h"
#import "KVAPIList.h"
#import "KVAPIObject.h"

@interface KVAPIClient ()

- (void)refreshList:(KVAPIList *)list force:(BOOL)force;
- (void)refreshObject:(KVAPIObject *)object force:(BOOL)force;

- (KVAPIObject *)sharedObjectOfType:(NSString *)type identifier:(NSString *)identifier;

@end

@interface KVAPIList ()

- (id)initWithAPIClient:(KVAPIClient *)APIClient;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong, readwrite) NSMutableArray *contents;

@property (nonatomic, assign, getter = isRefreshing, readwrite) BOOL refreshing;
@property (nonatomic, strong, readwrite) NSDate *lastRefreshDate;

@end

@interface KVAPIObject ()

- (id)initWithAPIClient:(KVAPIClient *)APIClient type:(NSString *)type identifier:(NSString *)identifier;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign, getter = isRefreshing, readwrite) BOOL refreshing;
@property (nonatomic, strong, readwrite) NSDate *lastRefreshDate;

- (void)updateWithDictionary:(NSDictionary *)dictionary nullifyOmittedKeys:(BOOL)nullify;

@end

#endif
