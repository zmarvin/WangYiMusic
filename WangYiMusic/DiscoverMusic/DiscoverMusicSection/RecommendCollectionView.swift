//
//  RecommendCollectionView.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/23.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
let leftGlideRefreshMoreViewWidth : CGFloat = 80
let imageView_titleLabel_ratio = CGFloat(0.65)
class RecommendCollectionView: UICollectionView {
    lazy var leftGlideRefreshMoreView: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        let t = "左\n滑\n更\n多"
        view.text = t
        view.numberOfLines = t.count
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 12)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    override var contentSize: CGSize{
        didSet{
            self.leftGlideRefreshMoreView.frame = CGRect(x: contentSize.width, y: 0, width: leftGlideRefreshMoreViewWidth, height: contentSize.height*imageView_titleLabel_ratio)
            self.addSubview(self.leftGlideRefreshMoreView)
        }
    }
    
}





