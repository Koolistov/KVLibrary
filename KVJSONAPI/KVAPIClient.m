//
//  KVAPIClient.m
//  KVLibrary
//
//  Created by Johan Kool on 6/6/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVAPIClient.h"

#import "KVAPIList.h"
#import "KVAPIObject.h"
#import "KVAPIPrivate.h"

@interface KVAPIClient () <NSKeyedUnarchiverDelegate, NSCoding, NSSecureCoding>

@property (nonatomic, strong, readwrite) NSURL *baseURL;

@property (nonatomic, strong) NSMutableDictionary *listsByURL;
@property (nonatomic, strong) NSMutableDictionary *objectsByType;

@end

@implementation KVAPIClient

#pragma mark - Initialization
- (id)init {
    return [self initWithBaseURL:nil];
}

- (id)initWithBaseURL:(NSURL *)baseURL {
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        self.listsByURL = [NSMutableDictionary dictionary];
        self.objectsByType = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Configuration
- (NSURL *)URLForListOfType:(NSString *)type {
    NSParameterAssert(type);
    
    NSString *relativeURLString = [NSString stringWithFormat:@"./%@", type];
    return [NSURL URLWithString:relativeURLString relativeToURL:self.baseURL];
}

- (NSURL *)URLForListOfType:(NSString *)type identifiers:(NSArray *)identifiers {
    NSParameterAssert(type);
    NSParameterAssert(identifiers);
    
    NSString *identifiersString = [identifiers componentsJoinedByString:@","];
    NSString *relativeURLString = [NSString stringWithFormat:@"./%@?ids=%@", type, identifiersString];
    return [NSURL URLWithString:relativeURLString relativeToURL:self.baseURL];
}

- (NSURL *)URLForObjectOfType:(NSString *)type identifier:(NSString *)identifier {
    NSParameterAssert(type);
    NSParameterAssert(identifier);
    
    NSString *relativeURLString = [NSString stringWithFormat:@"./%@/%@", type, identifier];
    return [NSURL URLWithString:relativeURLString relativeToURL:self.baseURL];
}

- (Class)classForObjectType:(NSString *)type {
    return [KVAPIObject class];
}

- (NSString *)objectTypeForRelationship:(NSString *)relationship inObjectType:(NSString *)type {
    return relationship;
}

#pragma mark - Main
- (KVAPIList *)listAtURL:(NSURL *)URL {
    NSParameterAssert(URL);
    
    NSString *absoluteURLString = [URL absoluteString];
    KVAPIList *list = self.listsByURL[absoluteURLString];
    if (!list) {
        list = [[KVAPIList alloc] initWithAPIClient:self];
        list.URL = URL;
        self.listsByURL[absoluteURLString] = list;
    }
    list.refreshing = YES;
    [self getJSONFromURL:URL force:NO onCompletion:^(id content, NSError *error){
        if (content) {
            // Add results to list
            NSMutableArray *contents = [list mutableArrayValueForKey:@"contents"];
            [contents removeAllObjects];
            [contents addObjectsFromArray:content];
            list.lastRefreshDate = [NSDate date];
        }
        list.refreshing = NO;
    }];
    return list;
}

- (KVAPIObject *)objectAtURL:(NSURL *)URL type:(NSString *)type identifier:(NSString *)identifier {
    NSParameterAssert(URL);
    NSParameterAssert(type);
    NSParameterAssert(identifier);
    
    KVAPIObject *object = [self sharedObjectOfType:type identifier:identifier];
    object.URL = URL;
    object.refreshing = YES;
    [self getJSONFromURL:URL force:NO onCompletion:^(id content, NSError *error) {
        if (content) object.lastRefreshDate = [NSDate date];
        object.refreshing = NO;
    }];
    return object;
}

- (void)refreshList:(KVAPIList *)list force:(BOOL)force {
    list.refreshing = YES;
    [self getJSONFromURL:list.URL force:force onCompletion:^(id content, NSError *error) {
        if (content) {
            // Remove current contents
            
            // Insert new content
            
            list.lastRefreshDate = [NSDate date];
        }
     list.refreshing = NO;
    }];
}

- (void)refreshObject:(KVAPIObject *)object force:(BOOL)force {
    object.refreshing = YES;
    [self getJSONFromURL:object.URL force:force onCompletion:^(id content, NSError *error) {
        if (content) object.lastRefreshDate = [NSDate date];
        object.refreshing = NO;
    }];
}

#pragma mark - Convenience
- (KVAPIList *)listOfType:(NSString *)type {
    NSParameterAssert(type);
  
    NSURL *URL = [self URLForListOfType:type];
    KVAPIList *list = [self listAtURL:URL];
    return list;
}

- (KVAPIList *)listOfType:(NSString *)type identifiers:(NSArray *)identifiers {
    NSParameterAssert(type);
    NSParameterAssert(identifiers);
    
    NSURL *URL = [self URLForListOfType:type identifiers:identifiers];
    KVAPIList *list = [self listAtURL:URL];
    return list;
}

- (KVAPIObject *)objectOfType:(NSString *)type identifier:(NSString *)identifier {
    NSParameterAssert(type);
    NSParameterAssert(identifier);
    
    NSURL *URL = [self URLForObjectOfType:type identifier:identifier];
    KVAPIObject *object = [self objectAtURL:URL type:type identifier:identifier];
    return object;
}

#pragma mark - Fetching
- (void)getJSONFromURL:(NSURL *)URL force:(BOOL)force onCompletion:(void (^)(id content, NSError *error))completionHandler {
    NSParameterAssert(URL);

#warning Mock method
    NSLog(@"GET URL: %@", URL);
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSData *data = [NSData dataWithContentsOfURL:URL];
        NSError *error;
        NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!JSONObject) {
            [KVAlertView showForError:error];
            if (completionHandler) completionHandler(nil, error);
        } else {
            id content = [self processJSONObject:JSONObject];
            if (completionHandler) completionHandler(content, nil);
        }
    });
}

#pragma mark - Processing
- (id)processJSONObject:(NSDictionary *)JSONObject {
    NSParameterAssert(JSONObject);
 
    __block id content = nil;
    [JSONObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if ([key isEqualToString:@"meta"]) {
            // Ignore for now
        } else if ([key isEqualToString:@"links"]) {
            // TODO
        } else if ([key isEqualToString:@"linked"]) {
            NSAssert([value isKindOfClass:[NSDictionary class]], @"Expected dictionary");
            [self processJSONObject:value];
        } else {
            NSAssert([value isKindOfClass:[NSArray class]], @"Expected array");
            content = [self processContent:value ofType:key];
        }
    }];
    return content;
}

- (id)processContent:(NSArray *)content ofType:(NSString *)type {
    NSParameterAssert(type);
 
    NSMutableDictionary *objects = self.objectsByType[type];
    if (!objects) {
        objects = [NSMutableDictionary dictionary];
        self.objectsByType[type] = objects;
    }

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[content count]];
    Class objectClass = [self classForObjectType:type];
    for (NSDictionary *contentDictionary in content) {
        NSString *identifier = contentDictionary[@"id"];
        id object = objects[identifier];
        if (!object) {
            object = [[objectClass alloc] initWithAPIClient:self type:type identifier:identifier];
            objects[identifier] = object;
        }
        [object updateWithDictionary:contentDictionary nullifyOmittedKeys:NO];
        [result addObject:object];
    }
    return  result;
}

- (KVAPIObject *)sharedObjectOfType:(NSString *)type identifier:(NSString *)identifier {
    NSParameterAssert(type);
    NSParameterAssert(identifier);
    
    NSMutableDictionary *objects = self.objectsByType[type];
    if (!objects) {
        objects = [NSMutableDictionary dictionary];
        self.objectsByType[type] = objects;
    }
    
    id object = objects[identifier];
    if (!object) {
        Class objectClass = [self classForObjectType:type];
        object = [[objectClass alloc] initWithAPIClient:self type:type identifier:identifier];
        objects[identifier] = object;
    }
    return object;
}

#pragma mark - Reset
- (void)flush {
    [self.objectsByType enumerateKeysAndObjectsUsingBlock:^(NSString *type, NSMutableDictionary *objects, BOOL *stop) {
        [objects enumerateKeysAndObjectsUsingBlock:^(id key, KVAPIObject *object, BOOL *stop) {
            [object updateWithDictionary:@{} nullifyOmittedKeys:YES];
        }];
        [objects removeAllObjects];
    }];
    [self.objectsByType removeAllObjects];
    
    // TODO: Flush lists?
}


#pragma mark - Persistence
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithBaseURL:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:0 forKey:@"version"];
    // Purposely do nothing, just for object to be able to set the right
    // APIClient instance
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)saveToDisk {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeInteger:0 forKey:@"version"];
    [archiver encodeObject:self.listsByURL forKey:@"listsByURL"];
    [archiver encodeObject:self.objectsByType forKey:@"objectsByType"];
    [archiver finishEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Cache", NSStringFromClass([self class])]];
    if ([data writeToFile:cachePath atomically:YES]) {
        NSLog(@"Data saved at %@", cachePath);
    } else {
        NSLog(@"Failed to save");
    }
}

- (void)restoreFromDisk {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Cache", NSStringFromClass([self class])]];
    NSData *data = [NSData dataWithContentsOfFile:cachePath];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        unarchiver.delegate = self;
        self.listsByURL = [unarchiver decodeObjectForKey:@"listsByURL"];
        self.objectsByType = [unarchiver decodeObjectForKey:@"objectsByType"];
        [unarchiver finishDecoding];
        NSLog(@"Data restored from %@", cachePath);
    }
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    if ([object isKindOfClass:[self class]]) {
        return self;
    } else {
        return object;
    }
}

@end
