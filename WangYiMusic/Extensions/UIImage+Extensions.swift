//
//  UIImage+Extensions.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/13.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

extension UIImage {
    
    func gaussianBlur() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)
        let parameters : [String : Any] = [
            kCIInputRadiusKey: 5,
            kCIInputImageKey: ciImage
        ]
        guard let lter = CIFilter(name: "CIGaussianBlur",parameters: parameters) else { return nil}
        guard let outputImage = lter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)) else { return nil }
        return UIImage(cgImage: cgImage)
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
}

