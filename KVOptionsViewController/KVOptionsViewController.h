//
//  KVOptionsViewController.h
//  KVLibrary
//
//  Created by Johan Kool on 23/7/2011.
//  Copyright (c) 2011-2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * `KVOptionsViewController` provides a generic way to let use pick an option from a list.
 */
@interface KVOptionsViewController : UITableViewController

/**
 * Labels for options to show in list.
 */
@property (nonatomic, strong) NSArray *optionLabels;

/**
 * Index of label that currently has the checkmark. Pass in NSNotFound if no current selection exists.
 */
@property NSUInteger currentSelection;

/**
 * Block that will be called when the user has selected an option from the list.
 */
@property (copy) void (^selectionHandler)(NSUInteger selectedOptionIndex);

@end
