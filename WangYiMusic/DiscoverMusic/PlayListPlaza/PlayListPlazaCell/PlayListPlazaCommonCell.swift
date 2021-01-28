//
//  PlayListPlazaCommonCell.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListPlazaCommonCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let playCountLabel = PlayCountLabel()
    let markImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
        shapeLayer.frame = self.bounds
        self.layer.mask = shapeLayer
        
//        imageView.layer.cornerRadius = 12
//        imageView.layer.masksToBounds = true
        imageView.cornersRound(radius: 12)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        imageView.addSubview(playCountLabel)
        imageView.addSubview(markImageView)
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 13)
        
        playCountLabel.textColor = .white
//        playCountLabel.backgroundColor = UIColor(red: 155/255.0, green: 140/255.0, blue: 160/255.0, alpha: 1)
        
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        
        let tempSize = self.playCountLabel.bounds.size
        playCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.width.equalTo(tempSize.width)
            make.height.equalTo(tempSize.height)
        }
        
        markImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
