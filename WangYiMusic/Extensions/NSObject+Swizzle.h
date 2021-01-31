//
//  NSObject+Swizzle.h
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
