//
//  UIViewController+Inject.m
//  testSwift
//
//  Created by mac on 2021/1/21.
//

#import "UIViewController+Inject.h"
#import <objc/runtime.h>

@implementation UIViewController (Inject)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        id obj = [[self alloc] init];
//        [obj swizzleMethod:@selector(viewWillLayoutSubviews) withMethod:@selector(viewWillLayoutSubviews_Inject)];
//        [obj swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(viewWillAppear_Inject:)];
//        [obj swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(viewDidAppear_Inject:)];
    });
}
static void *viewWillLayoutSubviews_InjectWithBlcokKey = &viewWillLayoutSubviews_InjectWithBlcokKey;
- (void)viewWillLayoutSubviews_InjectWithBlcok:(JnjectWithBlcok)block{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewWillLayoutSubviews) withMethod:@selector(viewWillLayoutSubviews_Inject)];
    });
    objc_setAssociatedObject(self, viewWillLayoutSubviews_InjectWithBlcokKey, block, OBJC_ASSOCIATION_RETAIN);
}
- (void)viewWillLayoutSubviews_Inject{
    [self viewWillLayoutSubviews_Inject];
    JnjectWithBlcok block = objc_getAssociatedObject(self, viewWillLayoutSubviews_InjectWithBlcokKey);
    if(block)block();
}

static void *viewDidLayoutSubviews_InjectWithBlcokKey = &viewDidLayoutSubviews_InjectWithBlcokKey;
- (void)viewDidLayoutSubviews_InjectWithBlcok:(JnjectWithBlcok)block{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewDidLayoutSubviews) withMethod:@selector(viewDidLayoutSubviews_Inject)];
    });
    objc_setAssociatedObject(self, viewDidLayoutSubviews_InjectWithBlcokKey, block, OBJC_ASSOCIATION_RETAIN);
}
- (void)viewDidLayoutSubviews_Inject{
    [self viewDidLayoutSubviews_Inject];
    JnjectWithBlcok block = objc_getAssociatedObject(self, viewDidLayoutSubviews_InjectWithBlcokKey);
    if(block)block();
}

static void *viewDidAppear_InjectWithBlcokKey = &viewDidAppear_InjectWithBlcokKey;
- (void)viewDidAppear_InjectWithBlcok:(JnjectWithBlcok)block{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(viewDidAppear_Inject:)];
    });
    objc_setAssociatedObject(self, viewDidAppear_InjectWithBlcokKey, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)viewDidAppear_Inject:(BOOL)animated{
    [self viewDidAppear_Inject:animated];
    JnjectWithBlcok block = objc_getAssociatedObject(self, viewDidAppear_InjectWithBlcokKey);
    if(block)block();
}

- (void)viewWillAppear_Inject:(BOOL)animated{
    [self viewWillAppear_Inject:animated];
}

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
