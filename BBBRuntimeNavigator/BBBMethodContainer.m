//
//  BBBMethodContainer.m
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBBMethodContainer.h"
#import <objc/runtime.h>

@implementation BBBMethodContainer
{
    Method _method;
}

- (id)initWithMethod:(Method)method
{
    if (self = [super init]) {
        _method = method;
    }
    return self;
}

- (NSString *)name
{
    return [NSString stringWithUTF8String:sel_getName(method_getName(_method))];
}

@end
