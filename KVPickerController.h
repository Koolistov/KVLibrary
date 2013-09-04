//
//  KVPickerController.h
//  Structures
//
//  Created by Johan Kool on 11/7/2013.
//  Copyright (c) 2013 Dancing Orangutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVPickerController : NSObject

/**
 * Picker view controlled by this controller. If none is set, one will be created for you. The datasource and delegate of the picker will be this controller.
 */
@property (nonatomic, strong) UIPickerView *pickerView;

/** @name Setup */

/**
 * Labels for options to show in the picker.
 */
@property (nonatomic, strong) NSArray *optionLabels;

/**
 * Index of label that currently is selected. Pass in NSNotFound if no current selection exists.
 */
@property NSUInteger currentSelection;

/** @name Handling response */

/**
 * Block that will be called when the user has selected an option from the picker.
 */
@property (copy) void (^selectionHandler)(NSUInteger selectedOptionIndex, NSString *selectedOptionLabel);

@end
