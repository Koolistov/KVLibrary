//
//  UIColor+KVUtilities.m
//  Flow Chart
//
//  Created by Johan Kool on 16/11/2012.
//  Copyright (c) 2012 Koolistov Pte. Ltd. All rights reserved.
//

#import "UIColor+KVUtilities.h"

// Borrows heavily from uicolor-utilities

@implementation UIColor (KVUtilities)

+ (UIColor *)kv_randomColor {
	return [UIColor colorWithRed:arc4random_uniform(255) / 255.0f
						   green:arc4random_uniform(255) / 255.0f
							blue:arc4random_uniform(255) / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)kv_colorFromHexString:(NSString *)hexString {
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) {
        return nil;
    }
	return [UIColor kv_colorWithRGBHex:hexNum];
}

+ (UIColor *)kv_colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;

	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

- (NSString *)kv_hexString {
    return [NSString stringWithFormat:@"%0.6X", (unsigned int)[self kv_rgbHex]];
}

- (UInt32)kv_rgbHex {
	NSAssert([self kv_canProvideRGBComponents], @"Must be a RGB color to use rgbHex");

	CGFloat r,g,b,a;
	if (![self kv_red:&r green:&g blue:&b alpha:&a]) return 0;

//	r = MIN(MAX(self.red, 0.0f), 1.0f);
//	g = MIN(MAX(self.green, 0.0f), 1.0f);
//	b = MIN(MAX(self.blue, 0.0f), 1.0f);

	return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}

- (BOOL)kv_canProvideRGBComponents {
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (BOOL)kv_red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);

	CGFloat r,g,b,a;

	switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}

	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;

	return YES;
}

@end
