//
//  KVOptionsViewController.m
//  KVLibrary
//
//  Created by Johan Kool on 23/7/2011.
//  Copyright (c) 2011-2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVOptionsViewController.h"

@implementation KVOptionsViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.optionLabels objectAtIndex:indexPath.row];
    if (indexPath.row == self.currentSelection) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelection = indexPath.row;
    if (self.selectionHandler) self.selectionHandler(indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
