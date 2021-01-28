//
//  UIView+Extensions.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/22.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

extension UIView {

    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    func screenShot() -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func screenShot_10Scale() -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 10)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func cornersRound(radius:CGFloat) {
        guard self.layer.mask == nil else {return}
        guard !__CGSizeEqualToSize(self.bounds.size, .zero) else {return}
        let size = CGSize(width: radius, height: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: size).cgPath
        self.layer.mask = maskLayer
    }
    
    func isDisplayedInScreen() -> Bool {
        
        if self.isHidden {
            return false
        }
        
        if self.superview == nil {
            return false
        }
        
        let rect = self.convert(self.frame, from: nil)
        if rect.isEmpty || rect.isNull{
            return false
        }
        
        if rect.size.equalTo(CGSize.zero) {
            return false
        }
        
        let screenRect = UIScreen.main.bounds
        let intersectionRect = rect.intersection(screenRect)
        if intersectionRect.isEmpty || intersectionRect.isNull {
            return false
        }
        
        return true
    }
}
