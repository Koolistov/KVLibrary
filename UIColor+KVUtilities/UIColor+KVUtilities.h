//
//  UIColor+KVUtilities.h
//  Flow Chart
//
//  Created by Johan Kool on 16/11/2012.
//  Copyright (c) 2012 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KVUtilities)

+ (UIColor *)kv_randomColor;

+ (UIColor *)kv_colorFromHexString:(NSString *)hexString;
+ (UIColor *)kv_colorWithRGBHex:(UInt32)hex;

- (NSString *)kv_hexString;
- (UInt32)kv_rgbHex;

- (BOOL)kv_canProvideRGBComponents;
- (BOOL)kv_red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

@end
