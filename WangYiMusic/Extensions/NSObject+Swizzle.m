//
//  NSObject+Swizzle.m
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/30.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
 
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
 
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
