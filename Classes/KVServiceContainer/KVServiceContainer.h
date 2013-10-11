//
//  KVServiceContainer.h
//  KVLibrary
//
//  Created by Johan Kool on 15/1/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * `KVServiceContainer` manages the storage and retrieval of services by acting as a central point of access in your app.
 */
@interface KVServiceContainer : NSObject

/** @name Public methods for accessing container */

/**
 * 
 * @return Shared instance of the service container
 */
+ (instancetype)sharedInstance;

@end
