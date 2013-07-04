//
//  BBBClassListViewController.m
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBBClassListViewController.h"
#import "BBBClassInspectorViewController.h"
#import "BBBClassContainer.h"

@interface BBBClassListViewController ()

@property (strong) NSArray *_classContainers;

@end

@implementation BBBClassListViewController

- (id)initWithSuperclass:(Class)superclass
{
    if (self = [super init]) {
        NSArray *containers = [BBBClassContainer subclassContainersOfClass:superclass];
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                   ascending:YES]];
        containers = [containers sortedArrayUsingDescriptors:sortDescriptors];
        self._classContainers = containers;
        
        BBBClassContainer *superclassContainer = [BBBClassContainer containerWithClass:superclass];
        self.title = superclassContainer ? [superclassContainer name] : @"Root classes";
    }
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._classContainers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ccci";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    BBBClassContainer *classContainer = self._classContainers[indexPath.row];
    cell.textLabel.text = [classContainer name];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBBClassContainer *classContainer = self._classContainers[indexPath.row];
    
    UIViewController *vc = [[BBBClassInspectorViewController alloc] initWithClass:classContainer.theClass];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    BBBClassContainer *classContainer = self._classContainers[indexPath.row];
    
    UIViewController *vc = [[BBBClassListViewController alloc] initWithSuperclass:classContainer.theClass];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
