//
//  KVAPIObject.m
//  KVLibrary
//
//  Created by Johan Kool on 6/6/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVAPIObject.h"

#import "KVAPIPrivate.h"

@interface KVAPIObject ()

@property (nonatomic, weak) KVAPIClient *APIClient;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSString *identifier;

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary *linkedObjects;

@end

@implementation KVAPIObject

- (id)initWithAPIClient:(KVAPIClient *)APIClient type:(NSString *)type identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.APIClient = APIClient;
        self.type = type;
        self.identifier = identifier;
        self.values = [NSMutableDictionary dictionary];
        self.linkedObjects = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.APIClient = [aDecoder decodeObjectOfClass:[KVAPIClient class] forKey:@"APIClient"];
        self.type = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"type"];
        self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
        self.URL = [aDecoder decodeObjectOfClass:[NSURL class] forKey:@"URL"];
        self.values = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:@"values"];
        self.linkedObjects = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:@"linkedObjects"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:0 forKey:@"version"];
    [aCoder encodeObject:self.APIClient forKey:@"APIClient"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.URL forKey:@"URL"];
    [aCoder encodeObject:self.values forKey:@"values"];
    [aCoder encodeObject:self.linkedObjects forKey:@"linkedObjects"];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary nullifyOmittedKeys:(BOOL)nullify {
    BOOL linkedObjectsHandled = NO;
    NSSet *combinedKeySet = [[NSSet setWithArray:[self.values allKeys]] setByAddingObjectsFromArray:[dictionary allKeys]];
    for (NSString *key in combinedKeySet) {
        if ([key isEqualToString:@"id"]) {
            // Skip
        } else if ([key isEqualToString:@"href"]) {
            // TODO
        } else if ([key isEqualToString:@"links"]) {
            // Handle linked objects
            NSDictionary *newLinks = dictionary[key];
            [self updateLinkedObjectsWithDictionary:newLinks nullifyOmittedKeys:nullify];
            linkedObjectsHandled = YES;
        } else {
            id currentValue = self.values[key];
            id newValue = dictionary[key];
            if (newValue) {
                if ([newValue isKindOfClass:[NSNull class]]) {
                    [self willChangeValueForKey:key];
                    [self.values removeObjectForKey:key];
                    [self didChangeValueForKey:key];
                } else if (![newValue isEqual:currentValue]) {
                    // TODO:     [self validateValue:newValue forKey:key error:&error];
                    
                    [self willChangeValueForKey:key];
                    self.values[key] = newValue;
                    [self didChangeValueForKey:key];
                }
            } else if (currentValue) {
                if (nullify)  {
                    [self willChangeValueForKey:key];
                    [self.values removeObjectForKey:key];
                    [self didChangeValueForKey:key];
                }
            }
        }
    }
    
    // If links weren't handled above, do so now if we need to nullify
    if (!linkedObjectsHandled && nullify) {
        [self updateLinkedObjectsWithDictionary:@{} nullifyOmittedKeys:YES];
    }
    
    self.lastRefreshDate = [NSDate date];
}

- (void)updateLinkedObjectsWithDictionary:(NSDictionary *)dictionary nullifyOmittedKeys:(BOOL)nullify {
    NSSet *combinedKeySet = [[NSSet setWithArray:[self.linkedObjects allKeys]] setByAddingObjectsFromArray:[dictionary allKeys]];
    for (NSString *key in combinedKeySet) {
        id currentValue = self.linkedObjects[key];
        id newValue = dictionary[key];
        if ([newValue isKindOfClass:[NSArray class]]) {
            NSMutableArray *newArray = [NSMutableArray array];
            NSString *type = [self.APIClient objectTypeForRelationship:key inObjectType:self.type];
            for (NSString *identifier in newValue) {
                KVAPIObject *object = [self.APIClient sharedObjectOfType:type identifier:identifier];
                [newArray addObject:object];
            }
            if (![currentValue isEqual:newArray]) {
                // TODO: This replaces array fully, should be smarter by doing mutations instead
                [self willChangeValueForKey:key];
                self.linkedObjects[key] = newArray;
                [self didChangeValueForKey:key];
            }
        } else if ([newValue isKindOfClass:[NSString class]]) {
            NSString *identifier = newValue;
            NSString *type = [self.APIClient objectTypeForRelationship:key inObjectType:self.type];
            KVAPIObject *object = [self.APIClient sharedObjectOfType:type identifier:identifier];
            if (![currentValue isEqual:object]) {
                [self willChangeValueForKey:key];
                self.linkedObjects[key] = object;
                [self didChangeValueForKey:key];
            }
        } else if ([newValue isKindOfClass:[NSNull class]]) {
            [self willChangeValueForKey:key];
            [self.linkedObjects removeObjectForKey:key];
            [self didChangeValueForKey:key];
        } else if (currentValue) {
            if (nullify)  {
                [self willChangeValueForKey:key];
                [self.linkedObjects removeObjectForKey:key];
                [self didChangeValueForKey:key];
            }
        }
    }
}

- (void)refreshWithForce:(BOOL)force {
    [self.APIClient refreshObject:self force:force];
}

- (id)objectForKey:(NSString *)key {
    id object = self.values[key];
    if (!object) {
        object = self.linkedObjects[key];
    }
    return object;
}

@end
