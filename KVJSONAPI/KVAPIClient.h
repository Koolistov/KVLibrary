//
//  KVAPIClient.h
//  KVLibrary
//
//  Created by Johan Kool on 6/6/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KVAPIObject;
@class KVAPIList;

/** Generic API client that can be used to access APIs conforming to the protocol described at http://jsonapi.org/.
 */

@interface KVAPIClient : NSObject

/** @name Initialization */

/** Creates an instance of the API client
 *
 * @param baseURL Base URL
 */
- (id)initWithBaseURL:(NSURL *)baseURL;

/** Base URL */
@property (nonatomic, strong, readonly) NSURL *baseURL;

/** @name Configuration */

/** URL to use to get list of a certain type
 *
 * @param type Type of list
 * @return URL to fetch list
 */
- (NSURL *)URLForListOfType:(NSString *)type;
- (NSURL *)URLForListOfType:(NSString *)type identifiers:(NSArray *)identifiers;
- (NSURL *)URLForObjectOfType:(NSString *)type identifier:(NSString *)identifier;

/** Class used to instantiate objects of a type.
 * 
 * This method is intended to be overwritten by subclasses. The returned class must be a subclass of KVAPIObject. The default is KVAPIObject.
 *
 * @param type Type of object
 */
- (Class)classForObjectType:(NSString *)type;

/** Type of object held in a relationship.
 * 
 * This method is intended to be overwritten by subclasses. 
 *
 * @param relationship Name of the relationship
 * @param type Type of object holding the relationship
 */
- (NSString *)objectTypeForRelationship:(NSString *)relationship inObjectType:(NSString *)type;

/** @name Main */

- (KVAPIList *)listAtURL:(NSURL *)URL;
- (KVAPIObject *)objectAtURL:(NSURL *)URL type:(NSString *)type identifier:(NSString *)identifier;

/** @name Convenience */

- (KVAPIList *)listOfType:(NSString *)type;
- (KVAPIList *)listOfType:(NSString *)type identifiers:(NSArray *)identifiers;
- (KVAPIObject *)objectOfType:(NSString *)type identifier:(NSString *)identifier;

/** @name Reset */

/** Flushes all objects, their contents and lists.
 */
- (void)flush;

/** @name Persistence */

/** Saves lists and objects to disk.
 *
 * The archive is saved in the caches directory and will be named after the class name.
 */
- (void)saveToDisk;

/** Restores lists and objects from disk if an archive is available. 
 *
 * This method overrides any current lists and objects, so calling right after initialization is usually the best time.
 */
- (void)restoreFromDisk;

@end
