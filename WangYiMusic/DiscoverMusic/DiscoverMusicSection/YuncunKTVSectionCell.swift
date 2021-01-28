//
//  YuncunKTVSectionCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/26.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import APNGKit

class YuncunKTVSectionCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let markbackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    let markImageView = APNGImageView(image: APNGImage(named: "EMDiscoverIcon.bundle/cm4_xiaobing_wave_ani"))
    let markLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleToFill

        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        
        setUpMarkBackgroundView()
 
        self.addSubview(imageView)
        self.imageView.addSubview(titleLabel)
        self.imageView.addSubview(markbackgroundEffectView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        markbackgroundEffectView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(markLabel.snp_bottom)
            make.height.equalTo(60)
        }
    }
    func setUpMarkBackgroundView() {
        
        self.markbackgroundEffectView.contentView.addSubview(self.markImageView)
        self.markbackgroundEffectView.contentView.addSubview(self.markLabel)
        
        markbackgroundEffectView.layer.cornerRadius = 10
        markbackgroundEffectView.layer.masksToBounds = true
        
        markLabel.text = "唱歌听歌"
        markLabel.textColor = .white
        markLabel.textAlignment = .center
        markLabel.font = UIFont.systemFont(ofSize: 11)
        markImageView.backgroundColor = .clear
        markImageView.startAnimating()
        
        self.markImageView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        self.markLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.markImageView.snp.right)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.cornersRound(radius: 8)
    }
}
