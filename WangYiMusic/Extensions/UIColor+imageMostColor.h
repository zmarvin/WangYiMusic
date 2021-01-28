//
//  UIColor+imageMostColor.h
//  testSwift
//
//  Created by mac on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (imageMostColor)
+ (UIColor*)mostColorWithImage:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
