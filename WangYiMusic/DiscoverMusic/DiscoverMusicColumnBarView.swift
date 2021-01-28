//
//  ColumnBarView.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/24.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation

class DiscoverMusicColumnBarView: UIScrollView {
    
    var personalFMBtn:EMDiscoverColumnBarCustomBtn
    var dayRecommendBtn:EMDiscoverColumnBarCustomBtn
    var musicListBtn:EMDiscoverColumnBarCustomBtn
    var rankingBtn:EMDiscoverColumnBarCustomBtn
    var anchorStationBtn:EMDiscoverColumnBarCustomBtn
    var liveBtn:EMDiscoverColumnBarCustomBtn
    var digitalAlbumBtn:EMDiscoverColumnBarCustomBtn
    var singChatBtn:EMDiscoverColumnBarCustomBtn
    
    var responder : (Int) -> ()
    
    init(responder:@escaping (Int) -> ()) {
        
        personalFMBtn = EMDiscoverColumnBarCustomBtn()
        dayRecommendBtn = EMDiscoverColumnBarCustomBtn()
        musicListBtn = EMDiscoverColumnBarCustomBtn()
        rankingBtn = EMDiscoverColumnBarCustomBtn()
        anchorStationBtn = EMDiscoverColumnBarCustomBtn()
        liveBtn = EMDiscoverColumnBarCustomBtn()
        digitalAlbumBtn = EMDiscoverColumnBarCustomBtn()
        singChatBtn = EMDiscoverColumnBarCustomBtn()
        
        self.responder = responder
        super.init(frame: CGRect.zero)
        self.showsHorizontalScrollIndicator = false
        setupSubviews()
        
    }
    
    func setupSubviews() {
        
        self.addSubview(personalFMBtn)
        self.addSubview(dayRecommendBtn)
        self.addSubview(musicListBtn)
        self.addSubview(rankingBtn)
        self.addSubview(anchorStationBtn)
        self.addSubview(liveBtn)
        self.addSubview(digitalAlbumBtn)
        self.addSubview(singChatBtn)
        
        personalFMBtn.setTitle("私人MF", for: UIControl.State.normal)
        personalFMBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_changliao"), for: UIControl.State.normal)
        personalFMBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        dayRecommendBtn.setTitle("每日推荐", for: UIControl.State.normal)
        dayRecommendBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_meirituijian"), for: UIControl.State.normal)
        dayRecommendBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        musicListBtn.setTitle("歌单", for: UIControl.State.normal)
        musicListBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_gedan"), for: UIControl.State.normal)
        musicListBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        rankingBtn.setTitle("排行榜", for: UIControl.State.normal)
        rankingBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_paihangbang"), for: UIControl.State.normal)
        rankingBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        anchorStationBtn.setTitle("电台", for: UIControl.State.normal)
        anchorStationBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_diantai"), for: UIControl.State.normal)
        anchorStationBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        liveBtn.setTitle("直播", for: UIControl.State.normal)
        liveBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_zhibo"), for: UIControl.State.normal)
        liveBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        digitalAlbumBtn.setTitle("数字专辑", for: UIControl.State.normal)
        digitalAlbumBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_shuzizhuanji"), for: UIControl.State.normal)
        digitalAlbumBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        singChatBtn.setTitle("唱聊", for: UIControl.State.normal)
        singChatBtn.setImage(UIImage(named: "EMDiscoverIcon.bundle/dic_changliao"), for: UIControl.State.normal)
        singChatBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
                
        personalFMBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview()
            make.height.equalToSuperview()
//            make.width.equalTo(superView).multipliedBy(0.2)
            make.width.equalTo(70)
        }
        
        dayRecommendBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(personalFMBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(personalFMBtn)
        }
        
        musicListBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(dayRecommendBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(dayRecommendBtn)
        }
        
        rankingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(musicListBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(musicListBtn)
        }
        
        anchorStationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(rankingBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(musicListBtn)
        }
        
        liveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(anchorStationBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(musicListBtn)
        }
        
        digitalAlbumBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(liveBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(musicListBtn)
        }
        
        singChatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personalFMBtn)
            make.left.equalTo(digitalAlbumBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(musicListBtn)
        }
        
        let contentSizeW = singChatBtn.frame.maxX
        self.contentSize = CGSize(width: contentSizeW, height: singChatBtn.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(btn:UIButton) {
        if let index = self.subviews.firstIndex(of: btn) {
            self.responder(index)
        }
    }
}


class EMDiscoverColumnBarCustomBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageH = CGFloat(40.0)
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {

        return CGRect(x: 0, y: 0, width: contentRect.size.width, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: imageH - 10, width: contentRect.size.width, height: contentRect.size.height-imageH)
    }
}
