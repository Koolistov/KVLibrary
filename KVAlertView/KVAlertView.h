//
//  KVAlertView.h
//  KVLibrary
//
//  Created by Johan Kool on 29/8/2012.
//  Copyright (c) 2012-2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVAlertView;

typedef void (^KVAlertViewBlock)(KVAlertView *alertView);

/** This subclass of UIAlertView adds support for blocks.

Sample usage:

    KVAlertView *alert = [KVAlertView alertWithTitle:NSLocalizedString(@"Title", @"")
                                             message:NSLocalizedString(@"Message", @"")
                                   cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                         cancelBlock:^(KVAlertView *alertView){
                                                         NSLog(@"Cancel");
                                                     }];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:NSLocalizedString(@"OK", @"") block:^(KVAlertView *alertView){
        NSLog(@"OK: %@", [alertView textFieldAtIndex:0].text);
    }];
    [alert show];
 
 */

@interface KVAlertView : UIAlertView

/** @name Creating alert */

/** Create an alert
 *
 * @param title Title in alert
 * @param message Message in alert
 * @param cancelButtonTitle Title of Cancel button in alert
 * @param cancelBlock Block to execute when Cancel button is pressed
 * 
 * @return Instance of KVAlertView
 */
+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock;

/** Create an alert
 *
 * @param title Title in alert
 * @param message Message in alert
 * @param cancelButtonTitle Title of Cancel button in alert
 * @param cancelBlock Block to execute when Cancel button is pressed
 * @param confirmButtonTitle Title of Confirm (OK) button in alert
 * @param confirmBlock Block to execute when Confirm button is pressed
 *
 * @return Instance of KVAlertView
 */
+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock
             confirmButtonTitle:(NSString *)confirmButtonTitle
                   confirmBlock:(KVAlertViewBlock)confirmBlock;

/** Create and immediately show an alert
 *
 * @param title Title in alert
 * @param message Message in alert
 * @param cancelButtonTitle Title of Cancel button in alert
 * @param cancelBlock Block to execute when Cancel button is pressed
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock;

/** Create and immediately show an alert
 *
 * @param title Title in alert
 * @param message Message in alert
 * @param cancelButtonTitle Title of Cancel button in alert
 * @param cancelBlock Block to execute when Cancel button is pressed
 * @param confirmButtonTitle Title of Confirm (OK) button in alert
 * @param confirmBlock Block to execute when Confirm button is pressed
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock
   confirmButtonTitle:(NSString *)confirmButtonTitle
         confirmBlock:(KVAlertViewBlock)confirmBlock;

/** Create and immediately show an alert for an NSError
 *
 * The error will also be logged if DEBUG is defined. The title is based on the localized description. The message is based on the localized failure reason and recovery suggestion. Buttons are addded for recovery options.
 *
 * @param error Error to show in alert
 */
+ (void)showForError:(NSError *)error;

/** @name Customizing alert */

/** Add a button to the alert
 *
 * @param title Title of button
 * @param block Block to execute when button is pressed
 *
 * @return Index of added button
 */
- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(KVAlertViewBlock)block;

@end
