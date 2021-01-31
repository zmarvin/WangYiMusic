//
//  UIViewController+DidLayoutInject.m
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/30.
//

#import "UIViewController+DidLayoutInject.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation UIViewController (DidLayoutInject)

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

@end
