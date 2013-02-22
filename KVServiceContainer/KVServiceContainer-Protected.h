//
//  KVServiceContainer-Protected.h
//  KVLibrary
//
//  Created by Johan Kool on 15/1/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

/**
 * The methods for KVServiceContainer are in a separate protected header named `KVServiceContainer-Protected.h`. It is only intended for use by its subclasses.
 */
@interface KVServiceContainer ()

/** @name Protected methods for storing and retrieving services */

/**
 * Retrieve a service with a particular key.
 *
 * @param serviceKey Key used to register the service
 *
 * @return The service registered for this key, or nil if no service has been registered
 */
- (id)serviceForKey:(NSUInteger)serviceKey;

/**
 * Retrieves a service with a particular key.
 *
 * If no service has been previously registered for this key, registers the result of initializer as the service for the key.
 *
 * @param serviceKey Key to use for registering the service
 * @param initializer Block returning the service to register
 *
 * @return Service registered for this key
 */
- (id)serviceForKey:(NSUInteger)serviceKey initializer:(id (^)(void))initializer;

/**
 * Register a service with a particular key.
 *
 * @param service Service to register
 * @param serviceKey Key to use for registering the service
 */
- (void)setService:(id)service forKey:(NSUInteger)serviceKey;

@end