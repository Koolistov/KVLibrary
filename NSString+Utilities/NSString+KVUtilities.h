//
//  NSString+KVUtilities.h
//  KVLibrary
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Koolistov Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KVUtilities)

/**
 * Returns a random string containing lowercase alphanummeric characters only
 */
+ (NSString *)kv_randomStringOfLength:(NSUInteger)length;

- (NSString *)kv_md5Hash;
- (NSString *)kv_sha1Hash;
- (NSString *)kv_sha256Hash;

- (NSString *)kv_decodeHTMLCharacterEntities;
- (NSString *)kv_encodeHTMLCharacterEntities;

@end
