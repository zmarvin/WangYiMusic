//
//  CustomArcView.swift
//  testSwift
//
//  Created by mac on 2021/1/5.
//

import Foundation
import UIKit

class PlayListControllerHeaderBackgroundView: UIView{
    
    var backgroundImageView = UIImageView()
    var imageViewHeight : CGFloat = 190
    private lazy var arcLayer: CAShapeLayer = {
        let arcLayer = CAShapeLayer()
        arcLayer.lineWidth = 1;
        let centerY : CGFloat = -3000
        let radius : CGFloat = abs(centerY)+imageViewHeight
        let startAngle = CGFloat(Double.pi)/2 - asin((frame.width/2)/radius)
        let endAngle = CGFloat(Double.pi)/2 + asin((frame.width/2)/radius)
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        arcLayer.path = path.cgPath
        arcLayer.fillColor = UIColor.white.cgColor
        return arcLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backgroundImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.frame.equalTo(.zero) {
            backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.imageViewHeight)
            backgroundImageView.layer.addSublayer(arcLayer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
