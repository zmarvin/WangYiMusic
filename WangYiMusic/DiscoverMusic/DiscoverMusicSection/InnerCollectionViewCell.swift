//
//  InnerCollectionViewCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/15.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class InnerCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let playCountLabel = PlayCountLabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleToFill
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        imageView.addSubview(playCountLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(imageView_titleLabel_ratio)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        let tempSize = self.playCountLabel.bounds.size
        playCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(tempSize.width)
            make.height.equalTo(tempSize.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.cornersRound(radius: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

