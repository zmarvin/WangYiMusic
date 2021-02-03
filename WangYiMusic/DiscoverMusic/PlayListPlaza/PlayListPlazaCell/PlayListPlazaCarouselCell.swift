//
//  PlayListPlazaCarouselCell.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListPlazaCarouselCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let frostedGlassView : UIView = UIView()
    let cornerBackgroundView = UIView()
//    let playBtn = UIButton()

    let playCountLabel = PlayCountLabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        cornerBackgroundView.layer.cornerRadius = 12
        cornerBackgroundView.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor.gray.cgColor
        
//        let playBtnWidth :CGFloat = 50
//        playBtn.layer.cornerRadius = playBtnWidth/2
//        playBtn.layer.masksToBounds = true
//        playBtn.backgroundColor = .white
//        playBtn.alpha = 0.7
//        playBtn.setImage(UIImage(named: "em_playlist_recommend_play"), for: UIControl.State.normal)
        
        self.addSubview(cornerBackgroundView)
        cornerBackgroundView.addSubview(imageView)
        cornerBackgroundView.addSubview(titleLabel)
        cornerBackgroundView.addSubview(frostedGlassView)
//        imageView.addSubview(playBtn)
        imageView.addSubview(playCountLabel)
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 13)
        
        playCountLabel.textColor = .white
        
        self.frostedGlassView.backgroundColor = .white
        self.frostedGlassView.alpha = 0

        cornerBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        
        let tempSize = self.playCountLabel.bounds.size
        playCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.width.equalTo(tempSize.width)
            make.height.equalTo(tempSize.height)
        }
        
//        playBtn.snp.makeConstraints { (make) in
//            make.right.bottom.equalToSuperview().offset(-10)
//            make.width.height.equalTo(playBtnWidth)
//        }
        
        self.frostedGlassView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
