//
//  KVActionSheet.m
//  KVLibrary
//
//  Created by Johan Kool on 18/1/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVActionSheet.h"

@interface KVActionSheet () <UIActionSheetDelegate>

@property (nonatomic, copy) KVActionSheetBlock cancelBlock;
@property (nonatomic, copy) KVActionSheetBlock destructiveBlock;
@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation KVActionSheet

+ (KVActionSheet *)actionSheetWithTitle:(NSString *)title
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       destructiveBlock:(KVActionSheetBlock)destructiveBlock
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                            cancelBlock:(KVActionSheetBlock)cancelBlock {
    KVActionSheet *actionSheet = [[KVActionSheet alloc] initWithTitle:title destructiveButtonTitle:destructiveButtonTitle destructiveBlock:destructiveBlock cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock];
    return actionSheet;
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    KVActionSheet *actionSheet = [self initWithTitle:title destructiveButtonTitle:destructiveButtonTitle destructiveBlock:nil cancelButtonTitle:cancelButtonTitle cancelBlock:nil];

    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)) {
        [actionSheet addButtonWithTitle:arg];
    }
    va_end(args);

    return actionSheet;
}

- (id)initWithTitle:(NSString *)title destructiveButtonTitle:(NSString *)destructiveButtonTitle destructiveBlock:(KVActionSheetBlock)destructiveBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(KVActionSheetBlock)cancelBlock {
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    if (self) {
        self.destructiveBlock = [destructiveBlock copy];
        self.cancelBlock = [cancelBlock copy];
        self.blocks = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(KVActionSheetBlock)block {
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    id blockOrNull = nil;
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        blockOrNull = self.destructiveBlock;
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        blockOrNull = self.cancelBlock;
    } else {
        blockOrNull = self.blocks[buttonIndex];
    }
    
    if (blockOrNull != nil && blockOrNull != [NSNull null]) {
        KVActionSheetBlock block = (KVActionSheetBlock)blockOrNull;
        block((KVActionSheet *)actionSheet);
    }
}

@end
