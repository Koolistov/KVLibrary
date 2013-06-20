//
//  KVAPIList.m
//  KVLibrary
//
//  Created by Johan Kool on 6/6/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVAPIList.h"

#import "KVAPIPrivate.h"

@interface KVAPIList ()

@property (nonatomic, weak) KVAPIClient *APIClient;

@end

@implementation KVAPIList

- (id)init {
    return  [self initWithAPIClient:nil];
}

- (id)initWithAPIClient:(KVAPIClient *)APIClient {
    NSParameterAssert(APIClient);
    self = [super init];
    if (self) {
        self.APIClient = APIClient;
        self.contents = [NSMutableArray array];
    }
    return  self;
}


+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.APIClient = [aDecoder decodeObjectOfClass:[KVAPIClient class] forKey:@"APIClient"];
        self.URL = [aDecoder decodeObjectOfClass:[NSURL class] forKey:@"URL"];
        self.contents = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"contents"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:0 forKey:@"version"];
    [aCoder encodeObject:self.APIClient forKey:@"APIClient"];
    [aCoder encodeObject:self.URL forKey:@"URL"];
    [aCoder encodeObject:self.contents forKey:@"contents"];
}

- (void)refreshWithForce:(BOOL)force {
    [self.APIClient refreshList:self force:force];
}

- (void)insertContents:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"contents"];
    [(NSMutableArray *)self.contents insertObjects:array atIndexes:indexes];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"contents"];
}

- (BOOL)canRearrangeArray:(NSArray *)existingArray intoArray:(NSArray *)newArray deleteIndexes:(NSIndexSet **)deleteIndexes insertIndexes:(NSIndexSet **)insertIndexes insertedObjects:(NSArray **)insertedObjects {
    NSParameterAssert(existingArray);
    NSParameterAssert(newArray);
    
    // old: b,c,d,e,f,h
    // new: a,c,e,f,g,h,i
    
    
    NSIndexSet *deleteIndexSet = [existingArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![newArray containsObject:obj];
    }];
    // del: 0,2 b,d
    
    
    NSIndexSet *toInsertIndexSet = [newArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![existingArray containsObject:obj];
    }];
    // ins: 0,4,6 a,g,i
    
    NSMutableIndexSet *remainingIndexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [existingArray count])];
    [remainingIndexSet removeIndexes:deleteIndexSet];
    NSArray *remainingArray = [existingArray objectsAtIndexes:remainingIndexSet];
    
    NSMutableIndexSet *remainingNewIndexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [newArray count])];
    [remainingNewIndexSet removeIndexes:toInsertIndexSet];
    NSArray *remainingNewArray = [existingArray objectsAtIndexes:remainingNewIndexSet];
    
    if (![remainingNewArray isEqualToArray:remainingArray]) {
        // There is also reordering
        return NO;
    }
    
    // del should be: 0,2 "b,c,d,e,f,h" -> "c,e,f,h"
    // ins should be: 0,4,6 "c,e,f,h -> "a,c,e,f,h" -> "a,c,e,f,g,h" -> "a,c,e,f,g,h,i"
    // ins arr should be: a,g,i
   
    NSArray *insertArray = [newArray objectsAtIndexes:toInsertIndexSet];
    // ins arr: a,g,i
    
    *deleteIndexes = deleteIndexSet;
    *insertIndexes = toInsertIndexSet;
    *insertedObjects = insertArray;

    return YES;
}

@end
