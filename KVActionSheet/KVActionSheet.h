//
//  KVActionSheet.h
//  KVLibrary
//
//  Created by Johan Kool on 18/1/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVActionSheet;

typedef void (^KVActionSheetBlock)(KVActionSheet *actionSheet);

@interface KVActionSheet : UIActionSheet

+ (KVActionSheet *)actionSheetWithTitle:(NSString *)title
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       destructiveBlock:(KVActionSheetBlock)destructiveBlock
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                            cancelBlock:(KVActionSheetBlock)cancelBlock;

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(KVActionSheetBlock)block;

@end
