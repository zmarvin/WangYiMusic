//
//  UIViewController+PopGestureState.m
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/30.
//

#import "UIViewController+PopGestureState.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

NSString *const WYScreenEdgePopGestureCancelledNotification = @"WYScreenEdgePopGestureCancelledNotification";
NSString *const WYScreenEdgePopGestureEndedNotification = @"WYScreenEdgePopGestureEndedNotification";

@implementation UIViewController (PopGestureState)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(willMoveToParentViewController:) withMethod:@selector(willMoveToParentViewController_InjectPopGestureState:)];
        [obj swizzleMethod:@selector(didMoveToParentViewController:) withMethod:@selector(didMoveToParentViewController_InjectPopGestureState:)];
        [obj swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(viewDidAppear_InjectPopGestureState:)];
    });
}

static bool isStartPopGesture = NO;
static bool isPopGestureCancelled = NO;

- (void)willMoveToParentViewController_InjectPopGestureState:(UIViewController *)parent{
    [self willMoveToParentViewController_InjectPopGestureState:parent];
    if (!parent) { // 开启pop
        isPopGestureCancelled = NO;
        isStartPopGesture = YES;
    }
}

- (void)didMoveToParentViewController_InjectPopGestureState:(UIViewController *)parent{
    [self didMoveToParentViewController_InjectPopGestureState:parent];
    if (!parent) { // pop结束
        isPopGestureCancelled = NO;
        isStartPopGesture = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:WYScreenEdgePopGestureEndedNotification object:self];
    }
}

- (void)viewDidAppear_InjectPopGestureState:(BOOL)animated{
    [self viewDidAppear_InjectPopGestureState:animated];
    if (isStartPopGesture) {// pop取消
        isPopGestureCancelled = YES;
        isStartPopGesture = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:WYScreenEdgePopGestureCancelledNotification object:self];
    }
}

@end
