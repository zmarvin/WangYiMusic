//
//  PlayListControllerHeaderView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListControllerSectionHeaderView: UIView {
    
    let playBtn = UIButton()
    let downloadBtn = UIButton()
    let editBtn = UIButton()
    let numLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(playBtn)
        self.addSubview(downloadBtn)
        self.addSubview(editBtn)
        self.addSubview(numLabel)
        
        playBtn.setImage(UIImage(named: "em_playlist_all"), for: UIControl.State.normal)
        playBtn.setTitle("播放全部", for: UIControl.State.normal)
        playBtn.setTitleColor(.black, for: UIControl.State.normal)
        playBtn.titleLabel?.contentMode = .center
        playBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        playBtn.imageView?.contentMode = .scaleAspectFit
        
        downloadBtn.setImage(UIImage(named: "em_playlist_down_new"), for: UIControl.State.normal)
        let editBtnImage = UIImage(named: "em_playlist_icn_edit_black")?.withRenderingMode(.alwaysTemplate)
        editBtn.setImage(editBtnImage, for: UIControl.State.normal)
        editBtn.imageView?.tintColor = .black
        
        numLabel.font = .systemFont(ofSize: 12)
        numLabel.textColor = .lightGray
        
        playBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(120)
        }
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playBtn.snp.right)
            make.bottom.equalTo(playBtn.snp.baseline).offset(3)
            make.width.equalTo(80)
            make.height.lessThanOrEqualToSuperview()
        }
        editBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        downloadBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.right.equalTo(editBtn.snp.left)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
