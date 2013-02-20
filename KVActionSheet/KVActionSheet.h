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

/** This subclass of UIActionSheet adds support for blocks. */
 
@interface KVActionSheet : UIActionSheet

/** @name Creating action sheet */

/** Create an action sheet
 *
 * @param title Title in action sheet
 * @param destructiveButtonTitle Title of the destructive (red) button in action sheet
 * @param destructiveBlock Block to execute when the destructive button is pressed
 * @param cancelButtonTitle Title of Cancel button in action sheet
 * @param cancelBlock Block to execute when Cancel button is pressed
 *
 * @return Instance of KVActionSheet
 */
+ (KVActionSheet *)actionSheetWithTitle:(NSString *)title
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       destructiveBlock:(KVActionSheetBlock)destructiveBlock
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                            cancelBlock:(KVActionSheetBlock)cancelBlock;

/** @name Customizing action sheet */

/** Add a button to the action sheet
 *
 * @param title Title of button
 * @param block Block to execute when button is pressed
 *
 * @return Index of added button
 */

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(KVActionSheetBlock)block;

@end
