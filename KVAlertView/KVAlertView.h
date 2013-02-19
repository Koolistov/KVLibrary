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

/**
 
 Sample usage:
 
 KVAlertView *alert = [KVAlertView alertWithTitle:NSLocalizedString(@"Title", @"") message:NSLocalizedString(@"Message", @"") cancelButtonTitle:NSLocalizedString(@"Cancel", @"") cancelBlock:^(KVAlertView *alertView){
     NSLog(@"Cancel");
 }];
 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
 [alert addButtonWithTitle:NSLocalizedString(@"OK", @"") block:^(KVAlertView *alertView){
     NSLog(@"OK: %@", [alertView textFieldAtIndex:0].text);
 }];
 [alert show];
 
 */

@interface KVAlertView : UIAlertView

+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock;

+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock
             confirmButtonTitle:(NSString *)confirmButtonTitle
                   confirmBlock:(KVAlertViewBlock)confirmBlock;

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(KVAlertViewBlock)block;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock
   confirmButtonTitle:(NSString *)confirmButtonTitle
         confirmBlock:(KVAlertViewBlock)confirmBlock;

@end
