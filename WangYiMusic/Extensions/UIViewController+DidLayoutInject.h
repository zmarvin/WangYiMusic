//
//  UIViewController+DidLayoutInject.h
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JnjectWithBlcok)(void);
@interface UIViewController (DidLayoutInject)
- (void)viewDidLayoutSubviews_InjectWithBlcok:(JnjectWithBlcok)block;
@end

NS_ASSUME_NONNULL_END
