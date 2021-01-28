//
//  PlayListAllCategoryCell.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/3.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListAllCategoryCell: UICollectionViewCell {
    
    let titleBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        self.layer.cornerRadius = 20
//        self.layer.masksToBounds = true
        self.cornersRound(radius: 20)
        titleBtn.backgroundColor = UIColor(red: 251/255.0, green: 249/255.0, blue: 251/255.0, alpha: 1)
        titleBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        titleBtn.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
