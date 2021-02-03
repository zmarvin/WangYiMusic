//
//  Kingfisher+Extensions.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/23.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import Kingfisher

extension Kingfisher where Base:UIImageView {
    
    func setImageAspectFillScale(with resource: Resource?, placeholder: Placeholder? = WY_PLACEHOLDER_IMAGE,completionHandler: CompletionHandler? = nil)  {
        self.setImage(with: resource, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: { (imageParam, error, cacheType, url) in
            guard let image = imageParam else {return}
            let size = self.base.bounds.size
            let scaledImage = image.aspectFillScaleToSize(newSize: size, scale: 2)
            guard image != scaledImage else {return}
            guard let unwrepScaledImage = scaledImage else {return}
            self.base.image = unwrepScaledImage
            guard let urlString = url?.absoluteString else {return}
            KingfisherManager.shared.cache.store(unwrepScaledImage, forKey: urlString)
            completionHandler?(unwrepScaledImage, error, cacheType, url)
        })
    }
}

extension KingfisherManager {
    
    func retrieveImageCompletionHandlerOnMainQueue(with resource: Resource?,completionHandler:CompletionHandler?)  {
        guard let resource = resource else {return}
        self.retrieveImage(with: resource, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            if Thread.isMainThread {
                completionHandler?(image, error, cacheType, url)
            } else {
                DispatchQueue.main.async { completionHandler?(image, error, cacheType, url) }
            }
        })
    }
}
