//
//  UIImage+blur.h
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (blur)
+ (UIImage *)boxBlurImage:(nullable UIImage *)image withBlurNumber:(CGFloat)blur;
@end


NS_ASSUME_NONNULL_END
