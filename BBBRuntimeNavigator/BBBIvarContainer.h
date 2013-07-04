//
//  BBBIvarContainer.h
//  BBBRuntimeNavigator
//
//  Created by Błażej Biesiada on 7/4/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct objc_ivar *Ivar;

@interface BBBIvarContainer : NSObject

- (id)initWithInstanceVariable:(Ivar)ivar;
- (NSString *)name;
- (NSString *)type;
- (NSString *)typeEncoding;

@end
