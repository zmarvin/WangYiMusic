//
//  MusicPlayInfoBarView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/11.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit

class MusicPlayInfoBarView: UIView {
    
    let loveBtn = UIButton() // 收藏
    let downloadBtn = UIButton()
    let singBtn = UIButton()
    let commentBtn = UIButton()
    let moreBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(loveBtn)
        self.addSubview(downloadBtn)
        self.addSubview(singBtn)
        self.addSubview(commentBtn)
        self.addSubview(moreBtn)
        
        singBtn.setImage(UIImage(named: "em_playinfo_icn_djreward_num_dis"), for: UIControl.State.normal)
        downloadBtn.setImage(UIImage(named: "em_playinfo_icn_dld"), for: UIControl.State.normal)
        commentBtn.setImage(UIImage(named: "em_playinfo_cmt_number"), for: UIControl.State.normal)
        moreBtn.setImage(UIImage(named: "em_playinfo_icn_more"), for: UIControl.State.normal)
        loveBtn.setImage(UIImage(named: "em_playinfo_icn_love"), for: UIControl.State.normal)
        
        singBtn.imageView?.contentMode = .scaleAspectFit
        downloadBtn.imageView?.contentMode = .scaleAspectFit
        commentBtn.imageView?.contentMode = .scaleAspectFit
        moreBtn.imageView?.contentMode = .scaleAspectFit
        loveBtn.imageView?.contentMode = .scaleAspectFit
        
        loveBtn.backgroundColor = UIColor.clear
        downloadBtn.backgroundColor = UIColor.clear
        singBtn.backgroundColor = UIColor.clear
        commentBtn.backgroundColor = UIColor.clear
        moreBtn.backgroundColor = UIColor.clear
        
        loveBtn.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(downloadBtn)
        }
        downloadBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(loveBtn.snp.right)
            make.width.equalTo(loveBtn)
        }
        singBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(downloadBtn.snp.right)
            make.width.equalTo(downloadBtn)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(singBtn.snp.right)
            make.width.equalTo(singBtn)
        }
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.right.equalToSuperview()
            make.left.equalTo(commentBtn.snp.right)
            make.width.equalTo(commentBtn)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
