//
//  BBBClassInspectorViewController.m
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBBClassInspectorViewController.h"
#import "BBBClassContainer.h"

@interface BBBClassInspectorViewController ()

@property (strong) BBBClassContainer *_classContainer;
@property (nonatomic, strong) NSArray *_methodContainers;

@end

@implementation BBBClassInspectorViewController

- (id)initWithClass:(Class)aClass
{
    if (self = [super init]) {
        self._classContainer = [BBBClassContainer containerWithClass:aClass];
        self.title = [self._classContainer name];
    }
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = [[self._classContainer ivarContainers] count];
            break;
        case 1:
            count = [self._methodContainers count];
    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"Instance variables";
            break;
        case 1:
            title = @"Instance methods";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ccci";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSString *label = nil;
    NSString *details = nil;
    
    switch (indexPath.section) {
        case 0: {
            BBBIvarContainer *ivarContainer = [self._classContainer ivarContainers][indexPath.row];
            label = [ivarContainer name];
            details = [ivarContainer type];
        }
            break;
        case 1: {
            BBBMethodContainer *methodContainer = self._methodContainers[indexPath.row];
            label = [methodContainer name];
        }
    }
    
    cell.textLabel.text = label;
    cell.detailTextLabel.text = details;
    
    return cell;
}

#pragma mark - BBBClassInspectorViewController ()

- (NSArray *)_methodContainers
{
    if (__methodContainers == nil) {
        __methodContainers = [self._classContainer methodContainers];
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                   ascending:YES]];
        __methodContainers = [__methodContainers sortedArrayUsingDescriptors:sortDescriptors];
    }
    return __methodContainers;
}

@end
