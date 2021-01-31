//
//  PlayListControllerHeaderView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PlayListControllerHeaderView: PlayListControllerHeaderBackgroundView {
    let disposeBag = DisposeBag()
    
    let imageView = UIImageView()
    let playCountLabel = PlayCountLabel()
    let titleLabel = UILabel()
    let creatorNicknameLabel = UILabel()
    let creatorAvatarImageView = UIImageView()
    let subscribeCreatorBtn = UIButton()
    
    let descriptionlabel = UILabel()
    let detailDescriptionBtn = UIButton()
    
    let beltBackgroundView = UIView()
    let subscribedCountBtn = UIButton()
    let commentCountBtn = UIButton()
    let shareCountBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(imageView)
        imageView.addSubview(playCountLabel)
        self.addSubview(titleLabel)
        self.addSubview(creatorAvatarImageView)
        self.addSubview(creatorNicknameLabel)
        self.addSubview(subscribeCreatorBtn)
        self.addSubview(descriptionlabel)
        self.addSubview(detailDescriptionBtn)
        self.addSubview(beltBackgroundView)
//        let beltContentView = UIView()
//        beltBackgroundView.addSubview(beltContentView)
        beltBackgroundView.addSubview(subscribedCountBtn)
        beltBackgroundView.addSubview(commentCountBtn)
        beltBackgroundView.addSubview(shareCountBtn)
        
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(125)
            make.height.equalTo(130)
        }
        
        playCountLabel.textColor = .white
        let tempSize = self.playCountLabel.bounds.size
        playCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.width.equalTo(tempSize.width)
            make.height.equalTo(tempSize.height)
        }
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(imageView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        
        let creatorAvatarImageViewWH : CGFloat = 30
        creatorAvatarImageView.layer.cornerRadius = creatorAvatarImageViewWH/2
        creatorAvatarImageView.layer.masksToBounds = true
        creatorAvatarImageView.contentMode = .scaleAspectFit
        creatorAvatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(imageView.snp.right).offset(15)
            make.height.equalTo(creatorAvatarImageViewWH)
            make.width.equalTo(creatorAvatarImageViewWH)
        }
        
        creatorNicknameLabel.font = .systemFont(ofSize: 12)
        creatorNicknameLabel.textColor = .white
        creatorNicknameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(creatorAvatarImageView)
            make.left.equalTo(creatorAvatarImageView.snp.right).offset(3)
            make.height.equalTo(creatorAvatarImageView)
            make.width.equalTo(100)
        }
        
        subscribeCreatorBtn.setImage(UIImage(named: "em_playlist_subscribe"), for: UIControl.State.normal)
        subscribeCreatorBtn.setBackgroundImage(UIImage(named: "em_playlist_subscribe_back"), for: UIControl.State.normal)
        subscribeCreatorBtn.snp.makeConstraints { (make) in
            make.left.equalTo(creatorNicknameLabel.snp.right)
            make.height.equalTo(20)
            make.width.equalTo(35)
            make.centerY.equalTo(creatorNicknameLabel.snp.centerY)
        }
        
        creatorNicknameLabel.rx.observe(\.text).subscribe(onNext: { [unowned self] string in
            guard let str = string else {return}
            let width : CGFloat = str.boundingRect(with: CGSize(width: 100, height: 100), font: self.creatorNicknameLabel.font).width
            creatorNicknameLabel.snp.updateConstraints { (make) in
                make.width.equalTo(width+5)
            }
        }).disposed(by: disposeBag)

        descriptionlabel.textColor = .white
        descriptionlabel.numberOfLines = 1
        descriptionlabel.font = .systemFont(ofSize: 12)
        descriptionlabel.snp.makeConstraints { (make) in
            make.left.equalTo(creatorAvatarImageView)
            make.bottom.equalTo(imageView)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-30)
        }
        
        detailDescriptionBtn.setImage(UIImage(named: "em_playlist_detail_arr"), for: UIControl.State.normal)
        detailDescriptionBtn.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionlabel.snp.right)
            make.top.height.equalTo(descriptionlabel)
            make.width.equalTo(detailDescriptionBtn.snp.height)
        }
        
        let beltBackgroundViewH : CGFloat = 45
        let roundedRect = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH - 55*2, height: beltBackgroundViewH)
        beltBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: beltBackgroundViewH/2).cgPath
        beltBackgroundView.layer.shadowRadius = 3
        beltBackgroundView.layer.shadowOpacity = 0.3
        beltBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        beltBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        beltBackgroundView.layer.cornerRadius = beltBackgroundViewH/2
        beltBackgroundView.layer.masksToBounds = false
        beltBackgroundView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.height.equalTo(beltBackgroundViewH)
        }
        beltBackgroundView.backgroundColor = .white
//        beltContentView.backgroundColor = .white
//        beltContentView.layer.cornerRadius = beltBackgroundViewH/2
//        beltContentView.layer.masksToBounds = true
        
        subscribedCountBtn.titleLabel?.contentMode = .center
        commentCountBtn.titleLabel?.contentMode = .center
        shareCountBtn.titleLabel?.contentMode = .center
        
        subscribedCountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        subscribedCountBtn.setImage(UIImage(named: "em_playlist_fav_new"), for: UIControl.State.normal)
        subscribedCountBtn.setTitle("100", for: UIControl.State.normal)
        subscribedCountBtn.setTitleColor(.black, for: UIControl.State.normal)
        
        commentCountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        commentCountBtn.setImage(UIImage(named: "em_playlist_cmt_new"), for: UIControl.State.normal)
        commentCountBtn.setTitle("100", for: UIControl.State.normal)
        commentCountBtn.setTitleColor(.black, for: UIControl.State.normal)
        
        shareCountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        shareCountBtn.setImage(UIImage(named: "em_playlist_share_new"), for: UIControl.State.normal)
        shareCountBtn.setTitle("100", for: UIControl.State.normal)
        shareCountBtn.setTitleColor(.black, for: UIControl.State.normal)
        
//        beltContentView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        subscribedCountBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        commentCountBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(subscribedCountBtn.snp.right)
            make.width.equalTo(subscribedCountBtn)
        }
        shareCountBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(commentCountBtn.snp.right)
            make.right.equalToSuperview()
        }
        self.setUpBottomBeltView()
    }
    
    func setUpBottomBeltView() {
        let bottomBeltBackgroundView = UIView()
        let leftIconImageView = UIImageView()
        let textLabel = UILabel()
        let arrowIcon = UIImageView()
        let subTextLabel = UILabel()

        self.addSubview(bottomBeltBackgroundView)
        bottomBeltBackgroundView.addSubview(leftIconImageView)
        bottomBeltBackgroundView.addSubview(textLabel)
        bottomBeltBackgroundView.addSubview(arrowIcon)
        bottomBeltBackgroundView.addSubview(subTextLabel)

        bottomBeltBackgroundView.layer.borderColor = UIColor.gray.cgColor
        bottomBeltBackgroundView.layer.borderWidth = 0.08
        bottomBeltBackgroundView.layer.cornerRadius = 8
        bottomBeltBackgroundView.layer.masksToBounds = true
        bottomBeltBackgroundView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-1)
        }
        
        leftIconImageView.contentMode = .scaleAspectFit
        leftIconImageView.image = UIImage(named: "em_playlist_icon_vip")?.withRenderingMode(.alwaysTemplate)
        leftIconImageView.tintColor = .red
        leftIconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        textLabel.text = "含3首VIP专享歌曲"
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .left
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftIconImageView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(150)
        }

        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.image = UIImage(named: "em_playlist_detail_arr")?.withRenderingMode(.alwaysTemplate)
        arrowIcon.tintColor = .gray
        arrowIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        subTextLabel.text = "首开VIP仅5元"
        subTextLabel.textAlignment = .right
        subTextLabel.font = .systemFont(ofSize: 12)
        subTextLabel.textColor = .gray
        subTextLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowIcon.snp.left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
