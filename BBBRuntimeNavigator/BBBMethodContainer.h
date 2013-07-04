//
//  BBBMethodContainer.h
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct objc_method *Method;

@interface BBBMethodContainer : NSObject

- (id)initWithMethod:(Method)method;
- (NSString *)name;

@end
