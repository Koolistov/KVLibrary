//
//  KVAlertView.m
//  KVLibrary
//
//  Created by Johan Kool on 29/8/2012.
//  Copyright (c) 2012-2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVAlertView.h"

@interface KVAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation KVAlertView

+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock {
    return [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock confirmButtonTitle:nil confirmBlock:nil];
}

+ (KVAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(KVAlertViewBlock)cancelBlock
             confirmButtonTitle:(NSString *)confirmButtonTitle
                   confirmBlock:(KVAlertViewBlock)confirmBlock {
    KVAlertView *alertView = [[KVAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock];
    if (confirmButtonTitle) {
        [alertView addButtonWithTitle:confirmButtonTitle block:confirmBlock];
    }
    return alertView;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    KVAlertView *alertView = [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)) {
        [alertView addButtonWithTitle:arg];
    }
    va_end(args);
    
    return alertView;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(KVAlertViewBlock)cancelBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        self.blocks = [NSMutableArray array];
        if (cancelButtonTitle) {
            if (cancelBlock) {
                self.blocks[0] = [cancelBlock copy];
            } else {
                self.blocks[0] = [NSNull null];
            }
        }
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
                     block:(KVAlertViewBlock)block {
    NSUInteger buttonIndex = [super addButtonWithTitle:title];
    if (block) {
        self.blocks[buttonIndex] = [block copy];
    } else {
        self.blocks[buttonIndex] = [NSNull null];
    }
    return buttonIndex;
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return [self addButtonWithTitle:title block:nil];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock {
    KVAlertView *alertView = [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock];
    [alertView show];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(KVAlertViewBlock)cancelBlock
   confirmButtonTitle:(NSString *)confirmButtonTitle
         confirmBlock:(KVAlertViewBlock)confirmBlock {
    KVAlertView *alertView = [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock confirmButtonTitle:confirmButtonTitle confirmBlock:confirmBlock];
    [alertView show];
}

+ (void)showForError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"Presenting alert for error: %@", error);
#endif
    
    NSString *title = [error localizedDescription];
    NSString *message = [NSString stringWithFormat:@"%@\n\n%@",
                         [error localizedFailureReason] ? [error localizedFailureReason] : @"",
                         [error localizedRecoverySuggestion] ? [error localizedRecoverySuggestion] : @""];
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    KVAlertView *alertView = [self alertWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") cancelBlock:nil];

    NSArray *suggestions = [error localizedRecoveryOptions];
    [suggestions enumerateObjectsUsingBlock:^(NSString *suggestion, NSUInteger idx, BOOL *stop) {
        [alertView addButtonWithTitle:suggestion block:^(KVAlertView *alertView) {
            BOOL result = [[error recoveryAttempter] attemptRecoveryFromError:error optionIndex:idx];
            if (!result) {
                [KVAlertView showForError:error];
            }
        }];
    }];

    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    id blockOrNull = self.blocks[buttonIndex];
    if (blockOrNull != [NSNull null]) {
        KVAlertViewBlock block = (KVAlertViewBlock)blockOrNull;
        block((KVAlertView *)alertView);
    }
}

@end
