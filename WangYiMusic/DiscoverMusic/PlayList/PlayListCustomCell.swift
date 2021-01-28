//
//  PlayListCustomCell.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/6.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListCustomCell: UITableViewCell {
    
    let indexLabel = UILabel()
    let titleLabel = UILabel()
    let creatorLabel = UILabel()
    private let exclusiveImageView = UIImageView()
    private let sqImageView = UIImageView()
    let isExclusive = false
    let isSq = false
    let mvBtn = UIButton()
    let moreBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(indexLabel)
        self.addSubview(titleLabel)
        self.addSubview(exclusiveImageView)
        self.addSubview(sqImageView)
        self.addSubview(creatorLabel)
        self.addSubview(mvBtn)
        self.addSubview(moreBtn)

        indexLabel.textColor = .lightGray
        indexLabel.textAlignment = .center
        creatorLabel.font = .systemFont(ofSize: 13)
        creatorLabel.textColor = UIColor.lightGray
        exclusiveImageView.image = UIImage(named: "em_playlist_icn_exclusive")
        sqImageView.image = UIImage(named: "em_playlist_icn_sq_new")
        
        let mvBtnImage = UIImage(named: "em_playlist_icn_video_new")?.withRenderingMode(.alwaysTemplate)
        mvBtn.setImage(mvBtnImage, for: UIControl.State.normal)
        mvBtn.imageView?.tintColor = .lightGray
        let moreBtnImage = UIImage(named: "em_playlist_moredot")?.withRenderingMode(.alwaysTemplate)
        moreBtn.setImage(moreBtnImage, for: UIControl.State.normal)
        moreBtn.imageView?.tintColor = .lightGray
        
        moreBtn.imageView?.contentMode = .scaleAspectFit
        exclusiveImageView.contentMode = .scaleAspectFit
        sqImageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indexLabelW :CGFloat = 50
        indexLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(indexLabelW)
        }
        let moreBtnW :CGFloat = 50
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview()
            make.width.equalTo(moreBtnW)
        }
        let mvBtnW :CGFloat = 30
        mvBtn.snp.makeConstraints { (make) in
            make.right.equalTo(moreBtn.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(mvBtnW)
        }
        let titleLabelW : CGFloat = WY_SCREEN_WIDTH - indexLabelW - moreBtnW - mvBtnW
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(indexLabel.snp.right)
            make.width.equalTo(titleLabelW)
            make.height.equalTo(30)
        }
        exclusiveImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(18)
            make.height.equalTo(11)
        }
        sqImageView.snp.makeConstraints { (make) in
            make.top.equalTo(exclusiveImageView)
            make.left.equalTo(exclusiveImageView.snp.right).offset(2)
            make.width.equalTo(exclusiveImageView)
            make.height.equalTo(exclusiveImageView)
        }
        creatorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(exclusiveImageView)
            make.left.equalTo(sqImageView.snp.right).offset(5)
            make.width.equalTo(titleLabelW-30*2)
            make.height.equalTo(exclusiveImageView)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
