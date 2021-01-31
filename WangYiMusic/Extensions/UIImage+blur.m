//
//  UIImage+blur.m
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/31.
//

#import "UIImage+blur.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (blur)

/**
 高斯模糊（对用content截图，opengl截图的图片发红处理高斯模糊）

 @param image 图片
 @param blur 1-100（最好是1-25）
 @return 高斯模糊图片
 */
+ (UIImage *)boxBlurImage:(nullable UIImage *)image withBlurNumber:(CGFloat)blur
{
    if(image==nil){
        return nil;
    }
    int boxSize = blur;
    if (blur<1||blur>100) {
        boxSize=25;
    }
    boxSize = boxSize - (boxSize % 2) + 1;

    CGImageRef img = image.CGImage;

    vImage_Buffer inBuffer, outBuffer, rgbOutBuffer;
    vImage_Error error;

    void *pixelBuffer, *convertBuffer;

    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    convertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    rgbOutBuffer.width = CGImageGetWidth(img);
    rgbOutBuffer.height = CGImageGetHeight(img);
    rgbOutBuffer.rowBytes = CGImageGetBytesPerRow(img);
    rgbOutBuffer.data = convertBuffer;

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );

    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    void *rgbConvertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    vImage_Buffer outRGBBuffer;
    outRGBBuffer.width = CGImageGetWidth(img);
    outRGBBuffer.height = CGImageGetHeight(img);
    outRGBBuffer.rowBytes = CGImageGetBytesPerRow(img);//3
    outRGBBuffer.data = rgbConvertBuffer;

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    const uint8_t mask[] = {2, 1, 0, 3};

    vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, kvImageNoFlags);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(rgbOutBuffer.data,
                                             rgbOutBuffer.width,
                                             rgbOutBuffer.height,
                                             8,
                                             rgbOutBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    //clean up
    CGContextRelease(ctx);

    free(pixelBuffer);
    free(convertBuffer);
    free(rgbConvertBuffer);
    CFRelease(inBitmapData);

    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);

    return returnImage;
}



@end
