//
//  MusicPlayBottomControlView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/7.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class MusicPlayBottomControlView: UIView {
    
    let controlBtn = UIButton()
    let nextBtn = UIButton()
    let lastBtn = UIButton()
    let loopBtn = UIButton()
    let menuBtn = UIButton()
    let progressBarView = MusicPlayProgressBarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(loopBtn)
        self.addSubview(lastBtn)
        self.addSubview(controlBtn)
        self.addSubview(nextBtn)
        self.addSubview(menuBtn)
        self.addSubview(progressBarView)
        
        controlBtn.setImage(UIImage(named: "em_vehicle_btn_play_prs"), for: UIControl.State.normal)
        controlBtn.setImage(UIImage(named: "em_vehicle_btn_pause_prs"), for: UIControl.State.selected)
        lastBtn.setImage(UIImage(named: "em_vehicle_btn_prev_prs"), for: UIControl.State.normal)
        nextBtn.setImage(UIImage(named: "em_vehicle_btn_next_prs"), for: UIControl.State.normal)
        menuBtn.setImage(UIImage(named: "em_vehicle_btn_src_white"), for: UIControl.State.normal)
        loopBtn.setImage(UIImage(named: "em_vehicle_loop_prs"), for: UIControl.State.normal)
        
        controlBtn.imageView?.contentMode = .scaleAspectFit
        lastBtn.imageView?.contentMode = .scaleAspectFit
        nextBtn.imageView?.contentMode = .scaleAspectFit
        menuBtn.imageView?.contentMode = .scaleAspectFit
        loopBtn.imageView?.contentMode = .scaleAspectFit
        
        loopBtn.backgroundColor = UIColor.clear
        lastBtn.backgroundColor = UIColor.clear
        controlBtn.backgroundColor = UIColor.clear
        nextBtn.backgroundColor = UIColor.clear
        menuBtn.backgroundColor = UIColor.clear
        let progressBarViewH :CGFloat = 10
        progressBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(progressBarViewH)
        }
        loopBtn.snp.makeConstraints { (make) in
            make.top.equalTo(progressBarView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(lastBtn)
        }
        lastBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.centerY.equalToSuperview().offset(progressBarViewH/2)
            make.left.equalTo(loopBtn.snp.right)
            make.width.equalTo(loopBtn)
        }
        controlBtn.snp.makeConstraints { (make) in
            make.top.equalTo(progressBarView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(lastBtn.snp.right)
            make.width.equalTo(lastBtn)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.centerY.equalToSuperview().offset(progressBarViewH/2)
            make.left.equalTo(controlBtn.snp.right)
            make.width.equalTo(controlBtn)
        }
        menuBtn.snp.makeConstraints { (make) in
            make.top.equalTo(progressBarView.snp.bottom)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(nextBtn.snp.right)
            make.width.equalTo(nextBtn)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
