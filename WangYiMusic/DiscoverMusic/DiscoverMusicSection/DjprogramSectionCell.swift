//
//  DjprogramSectionCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/26.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class DjprogramSectionCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let playBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleToFill
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)

        self.imageView.addSubview(self.playBtn)
        self.playBtn.setImage(UIImage(named: "cm2_vehicle_btn_play"), for: .normal)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.frame = CGRect(x: 10, y: 10, width: frame.width-20, height: frame.width-20)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalToSuperview().multipliedBy(0.4).offset(5)
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.cornersRound(radius: imageView.frame.width/2)
    }
}
