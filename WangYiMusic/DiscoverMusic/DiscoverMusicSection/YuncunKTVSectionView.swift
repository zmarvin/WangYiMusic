//
//  YuncunKTVSectionView.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/26.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class YuncunKTVSectionView: UICollectionView {
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
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            guard let a = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0)) else { return }
            
            self.leftGlideRefreshMoreView.frame = CGRect(x: contentSize.width, y: a.frame.origin.x, width: leftGlideRefreshMoreViewWidth, height: layout.itemSize.height)
            self.addSubview(self.leftGlideRefreshMoreView)

        }
    }
    
}
