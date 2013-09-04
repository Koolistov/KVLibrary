//
//  KVPickerController.m
//  Structures
//
//  Created by Johan Kool on 11/7/2013.
//  Copyright (c) 2013 Dancing Orangutan. All rights reserved.
//

#import "KVPickerController.h"

@interface KVPickerController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *_pickerView;
    NSUInteger _currentSelection;
}

@end

@implementation KVPickerController

#pragma mark - Accessors
- (void)setPickerView:(UIPickerView *)pickerView {
    if (_pickerView != pickerView) {
        _pickerView = pickerView;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView selectRow:_currentSelection inComponent:0 animated:NO];
    }
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        self.pickerView = [UIPickerView new];
    }
    return _pickerView;
}

- (void)setOptionLabels:(NSArray *)optionLabels {
    if (_optionLabels != optionLabels) {
        _optionLabels = optionLabels;
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:_currentSelection inComponent:0 animated:NO];
    }
}

- (void)setCurrentSelection:(NSUInteger)currentSelection {
    [_pickerView selectRow:currentSelection inComponent:0 animated:NO];
    _currentSelection = currentSelection;
}

- (NSUInteger)currentSelection {
    return _currentSelection;
}

#pragma mark - Picker view datasource and delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.optionLabels count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.optionLabels[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentSelection = row;
    if (self.selectionHandler) self.selectionHandler(row, self.optionLabels[row]);
}

@end
