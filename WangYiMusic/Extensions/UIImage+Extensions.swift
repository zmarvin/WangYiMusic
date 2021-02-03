//
//  UIImage+Extensions.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/13.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import Accelerate

extension UIImage {
    
    func cut(rect:CGRect) -> UIImage? {
        guard let image = self.cgImage?.cropping(to:rect) else { return nil }
        return UIImage(cgImage: image)
    }
    
    func reSize(newSize:CGSize,scale:Int) -> UIImage? {
        if __CGSizeEqualToSize(self.size, newSize) {
            return self
        }
        let finalScale = (0 == scale) ? Int(UIScreen.main.scale) : scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, CGFloat(finalScale))
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func gaussianBlur() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)
        let parameters : [String : Any] = [
            kCIInputRadiusKey: 10,
            kCIInputImageKey: ciImage
        ]
        guard let lter = CIFilter(name: "CIGaussianBlur",parameters: parameters) else { return nil}
        guard let outputImage = lter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    // 有变色问题
    class func swift_boxBlurImage(_ image: UIImage?, withBlurNumber blur: CGFloat) -> UIImage? {
        guard let image = image else { return nil }

        var boxSize = 0
        if blur < 1 || blur > 100 {
            boxSize = 25
        }
        boxSize = boxSize - (boxSize % 2) + 1

        guard let img = image.cgImage else { return nil }
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var rgbOutBuffer = vImage_Buffer()
        
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutableRawPointer
        var convertBuffer: UnsafeMutableRawPointer
        
        // 从CGImage中获取数据
        guard let inProvider = img.dataProvider else { return nil }
        let inBitmapData = inProvider.data
        
        convertBuffer = malloc(img.bytesPerRow * img.height)
        rgbOutBuffer.width = UInt(img.width)
        rgbOutBuffer.height = UInt(img.height)
        rgbOutBuffer.rowBytes = img.bytesPerRow
        rgbOutBuffer.data = convertBuffer
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(img.width)
        inBuffer.height = UInt(img.height)
        inBuffer.rowBytes = img.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        pixelBuffer = malloc(img.bytesPerRow * img.height)
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img.width)
        outBuffer.height = UInt(img.height)
        outBuffer.rowBytes = img.bytesPerRow
        
        let rgbConvertBuffer = malloc(img.bytesPerRow * img.height)
        var outRGBBuffer = vImage_Buffer()
        outRGBBuffer.width = UInt(img.width)
        outRGBBuffer.height = UInt(img.height)
        outRGBBuffer.rowBytes = img.bytesPerRow
        outRGBBuffer.data = rgbConvertBuffer
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            NSLog("error from convolution %ld", error)
        }

        let mask : [UInt8] = [2, 1, 0, 3]
        vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, vImage_Flags(kvImageNoFlags))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
        
        let imageRef = ctx.makeImage()!
        let returnImage = UIImage(cgImage: imageRef)
        
        free(pixelBuffer)
        free(convertBuffer)
        free(rgbConvertBuffer)
        
        return returnImage
    }
    
    func aspectFillScaleToSize(newSize:CGSize,scale:Int) -> UIImage? {
        if __CGSizeEqualToSize(self.size, newSize) {
            return self
        }
        
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width / self.size.width
        let aspectHeight = newSize.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        let finalScale = (0 == scale) ? Int(UIScreen.main.scale) : scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, CGFloat(finalScale))
        self.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func aspectFitScaleToSize(newSize:CGSize,scale:Int) -> UIImage? {
        if __CGSizeEqualToSize(self.size, newSize) {
            return self
        }
        
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width / self.size.width
        let aspectHeight = newSize.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        let finalScale = (0 == scale) ? Int(UIScreen.main.scale) : scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, CGFloat(finalScale))
        self.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    // 耗时太久，暂用oc版本
   var mostColor:UIColor {
       //获取图片信息
       let imgWidth:Int = Int(self.size.width)/2
       let imgHeight:Int = Int(self.size.height)/2
       //位图的大小＝图片宽＊图片高＊图片中每点包含的信息量
       let bitmapByteCount = imgWidth * imgHeight * 4
       //使用系统的颜色空间
       let colorSpace = CGColorSpaceCreateDeviceRGB()
       //根据位图大小，申请内存空间
       let bitmapData = malloc(bitmapByteCount)
       defer {free(bitmapData)}
       //创建一个位图
       let context = CGContext(data: bitmapData,
                                width: imgWidth,
                                height: imgHeight,
                                bitsPerComponent:8,
                                bytesPerRow: imgWidth * 4,
                                space: colorSpace,
                                bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)
       //图片的rect
       let rect = CGRect(x:0, y:0, width:CGFloat(imgWidth), height:CGFloat(imgHeight))
       //将图片画到位图中
        context?.draw(self.cgImage!, in: rect)
       //获取位图数据
       let bitData = context?.data
       let data = unsafeBitCast(bitData, to:UnsafePointer<CUnsignedChar>.self)
       let cls = NSCountedSet.init(capacity: imgWidth * imgHeight)
       for x in 0..<imgWidth {
           for y in 0..<imgHeight {
               let offSet = (y * imgWidth + x)*4
               let r = (data + offSet).pointee
               let g = (data + offSet+1).pointee
               let b = (data + offSet+2).pointee
               let a = (data + offSet+3).pointee
               if a > 0 {
                   //去除透明
                   if !(r == 255 && g == 255 && b == 255) {
                       //去除白色
                        cls.add([CGFloat(r),CGFloat(g),CGFloat(b),CGFloat(a)])
                    }
                }
            }

        }

       //找到出现次数最多的颜色
       let enumerator = cls.objectEnumerator()
       var maxColor:Array<CGFloat>? = nil
       var maxCount = 0
       while let curColor = enumerator.nextObject() {
           let tmpCount = cls.count(for: curColor)
           if tmpCount >= maxCount{
                maxCount = tmpCount
                maxColor = curColor as? Array<CGFloat>
            }
        }
       return UIColor.init(red: (maxColor![0]/255), green: (maxColor![1]/255), blue: (maxColor![2]/255), alpha: (maxColor![3]/255))
    }
}

