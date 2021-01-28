//
//  MusicPlayTopBarView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/10.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class MusicPlayTopBarView: UIView {
    
    let backBtn = UIButton()
    let rightBtn = UIButton()
    
    let titleView = UIView()
    let titleLabel = UILabel()
    let creatorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backBtn)
        self.addSubview(rightBtn)
        self.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(creatorLabel)
        
        backBtn.setImage(UIImage(named: "em_play_icon_back"), for: UIControl.State.normal)
        rightBtn.setImage(UIImage(named: "em_vehicle_icn_share"), for: UIControl.State.normal)
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        creatorLabel.textColor = .white
        creatorLabel.font = .systemFont(ofSize: 13)
        creatorLabel.textAlignment = .center
        
        backBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        titleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(170)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        creatorLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
