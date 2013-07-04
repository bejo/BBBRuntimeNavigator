//
//  BBBIvarContainer.m
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBBIvarContainer.h"
#import <objc/runtime.h>

@implementation BBBIvarContainer
{
    Ivar _ivar;
}

- (id)initWithInstanceVariable:(Ivar)ivar
{
    if (self = [super init]) {
        _ivar = ivar;
    }
    return self;
}

- (NSString *)name
{
    return [NSString stringWithUTF8String:ivar_getName(_ivar)];
}

- (NSString *)type
{
    NSString *typeEncoding = [self typeEncoding];
    NSString *type = nil;
    
    NSDictionary *encodingMap = @{@"c" : @"char",
                                  @"i" : @"int",
                                  @"s" : @"short",
                                  @"l" : @"long",
                                  @"q" : @"long long",
                                  @"C" : @"unsigned char",
                                  @"I" : @"unsigned int",
                                  @"S" : @"unsigned short",
                                  @"L" : @"unsigned long",
                                  @"Q" : @"unsigned long long",
                                  @"f" : @"float",
                                  @"d" : @"double",
                                  @"B" : @"bool",
                                  @"v" : @"void",
                                  @"*" : @"char *",
                                  @"@" : @"An Object",
                                  @"#" : @"A class object",
                                  @":" : @"SEL"};
    
    //TODO: Add missing types and add handling of complex object (arrays, structures etc).
    
    type = encodingMap[typeEncoding];
    
    if (type == nil) {
        type = typeEncoding;
    }
    
    return type;
}

- (NSString *)typeEncoding
{
    return [NSString stringWithUTF8String:ivar_getTypeEncoding(_ivar)];
}

- (NSString *)description
{
    return [self name];
}

@end
