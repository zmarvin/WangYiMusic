//
//  ProgressBarView.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/31.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation

class MusicPlayProgressBarView: UIView {
    
    let leftTimeLable = UILabel()
    let rightTimeLable = UILabel()
    let progressBackView = UIView()
    let sliderView = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(leftTimeLable)
        self.addSubview(rightTimeLable)
        self.addSubview(progressBackView)
        self.addSubview(sliderView)
        
        sliderView.isContinuous = false
        sliderView.setThumbImage(UIImage(named: "em_play_sliderthumb"), for: UIControl.State.normal)
        sliderView.setThumbImage(UIImage(named: "em_play_sliderthumb_prs"), for: UIControl.State.highlighted)
        sliderView.minimumTrackTintColor = UIColor(red: 175/255.0, green: 175/255.0, blue: 175/255.0, alpha: 0.7)
        leftTimeLable.font = UIFont.systemFont(ofSize: 10)
        leftTimeLable.textAlignment = .center
        leftTimeLable.text = "00:00"
        leftTimeLable.textColor = .white
        
        rightTimeLable.font = UIFont.systemFont(ofSize: 10)
        rightTimeLable.textAlignment = .center
        rightTimeLable.text = "00:00"
        rightTimeLable.textColor = .white
        
        leftTimeLable.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        rightTimeLable.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        progressBackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftTimeLable.snp.right)
            make.right.equalTo(rightTimeLable.snp.left)
        }
        sliderView.snp.makeConstraints { (make) in
            make.left.top.bottom.width.equalTo(progressBackView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
