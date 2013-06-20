//
//  KVAPIList.h
//  KVLibrary
//
//  Created by Johan Kool on 6/6/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVAPIList : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong, readonly) NSArray *contents;

- (void)refreshWithForce:(BOOL)force;
@property (nonatomic, assign, getter = isRefreshing, readonly) BOOL refreshing;
@property (nonatomic, strong, readonly) NSDate *lastRefreshDate;

@end

