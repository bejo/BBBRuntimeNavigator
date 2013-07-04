//
//  BBBClassContainer.m
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/3/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBBClassContainer.h"
#import <objc/runtime.h>

@interface BBBClassContainer ()

+ (NSMutableDictionary *)_classNameToContainerMap;
+ (NSString *)_nameOfClass:(Class)aClass;

- (id)_initWithClass:(Class)aClass;

@end

@implementation BBBClassContainer
{
    Class _class;
    NSArray *_ivarContainers;
}

+ (id)containerWithClass:(Class)aClass
{
    BBBClassContainer *classContainer = nil;
    NSString *className = [BBBClassContainer _nameOfClass:aClass];
    
    if (className != nil) {
        NSDictionary *nameToContainerMap = [BBBClassContainer _classNameToContainerMap];
        classContainer = nameToContainerMap[className];
        
        if (classContainer == nil) {
            classContainer = [[BBBClassContainer alloc] _initWithClass:aClass];
        }
    }
    
    return classContainer;
}

+ (NSArray *)subclassContainersOfClass:(Class)superclass
{
    NSMutableArray *subclassContainers = [NSMutableArray array];
    
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0) {
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for (int i=0; i<numClasses; i++) {
            Class class = classes[i];
            
            if (class_getSuperclass(class) == superclass) {
                [subclassContainers addObject:[BBBClassContainer containerWithClass:class]];
            }
        }
        
        free(classes);
    }
    
    return subclassContainers;
}

- (Class)theClass
{
    return _class;
}

- (NSArray *)ivarContainers
{
    if (_ivarContainers == nil) {
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList(self.theClass, &outCount);
        NSMutableArray *ivarContainers = [NSMutableArray arrayWithCapacity:outCount];
        
        for (int i=0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            BBBIvarContainer *container;
            container = [[BBBIvarContainer alloc] initWithInstanceVariable:ivar];
            [ivarContainers addObject:container];
        }
        
        free(ivars);
        _ivarContainers = [ivarContainers copy];
    }
    
    return _ivarContainers;
}

- (BBBClassContainer *)superclassContainer
{
    Class superclass = class_getSuperclass(_class);
    BBBClassContainer *superclassContainer = [BBBClassContainer containerWithClass:superclass];
    return superclassContainer;
}

- (NSArray *)subclassContainers
{
    return [BBBClassContainer subclassContainersOfClass:_class];
}

- (NSArray *)methodContainers
{
    unsigned int outCount;
    Method *methods = class_copyMethodList(_class, &outCount);
    NSMutableArray *methodContainers = [NSMutableArray arrayWithCapacity:outCount];
    
    for (int i=0; i<outCount; i++) {
        Method method = methods[i];
        [methodContainers addObject:[[BBBMethodContainer alloc] initWithMethod:method]];
    }
    free(methods);
    
    return methodContainers;
}

- (BOOL)isRootClass
{
    return [self superclassContainer] == nil;
}

- (NSString *)name
{
    return [BBBClassContainer _nameOfClass:_class];
}

- (int)version
{
    return class_getVersion(_class);
}

- (NSString *)description
{
    return [self name];
}

#pragma mark - BBBClassContainer ()

+ (NSMutableDictionary *)_classNameToContainerMap
{
    static NSMutableDictionary *classNameToContainerMap = nil;
    if (classNameToContainerMap == nil) {
        classNameToContainerMap = [NSMutableDictionary dictionary];
    }
    return classNameToContainerMap;
}

+ (NSString *)_nameOfClass:(Class)aClass
{
    return [NSString stringWithUTF8String:class_getName(aClass)];
}

- (id)_initWithClass:(Class)aClass
{
    self = [super init];
    
    if (self && aClass != nil) {
        _class = aClass;
        
        NSString *name = [self name];
        [BBBClassContainer _classNameToContainerMap][name] = self;
    }
    else {
        self = nil;
    }
    
    return self;
}

@end
