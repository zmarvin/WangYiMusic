//
//  MusicPlayShrinkControlPannelProgressBtn.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/14.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class MusicPlayShrinkControlPannelProgressBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "em_play_pannel_play"), for: UIControl.State.normal)
        self.setImage(UIImage(named: "em_play_pannel_pause"), for: UIControl.State.selected)
    }
    
    var progress : CGFloat = 0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        UIColor.lightGray.set()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = rect.width/2 - 10
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: WY_M_PI*2, clockwise: true)
        path.lineWidth = 1.5
        path.stroke()
        
        UIColor.black.set()
        let progressStartAngle = -WY_M_PI/2
        let progressEndAngle = progress * WY_M_PI*2 - WY_M_PI/2
        let path1 = UIBezierPath(arcCenter: center, radius: radius, startAngle: progressStartAngle, endAngle: progressEndAngle, clockwise: true)
        path1.lineWidth = 1.5
        path1.stroke()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
