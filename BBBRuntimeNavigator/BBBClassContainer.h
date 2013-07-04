//
//  BBBClassContainer.h
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/3/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBBIvarContainer.h"
#import "BBBMethodContainer.h"

@interface BBBClassContainer : NSObject

+ (id)containerWithClass:(Class)aClass;
+ (NSArray *)subclassContainersOfClass:(Class)superclass;

@property (readonly) Class theClass;
@property (readonly) NSArray *ivarContainers;

- (BBBClassContainer *)superclassContainer;
- (NSArray *)subclassContainers;
- (NSArray *)methodContainers;
- (BOOL)isRootClass;
- (NSString *)name;
- (int)version;

@end
