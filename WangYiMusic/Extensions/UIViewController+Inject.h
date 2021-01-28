//
//  UIViewController+Inject.h
//  testSwift
//
//  Created by mac on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JnjectWithBlcok)(void);
@interface UIViewController (Inject)
- (void)viewWillLayoutSubviews_InjectWithBlcok:(JnjectWithBlcok)block;
- (void)viewDidLayoutSubviews_InjectWithBlcok:(JnjectWithBlcok)block;
- (void)viewDidAppear_InjectWithBlcok:(JnjectWithBlcok)block;
@end

NS_ASSUME_NONNULL_END
