//
//  CustomArcView.swift
//  testSwift
//
//  Created by mac on 2021/1/5.
//

import Foundation
import UIKit
class PlayListCustomArcView: UIView {
    var downBackgroundColor = UIColor.white
    override func draw(_ rect: CGRect) {
        downBackgroundColor.set()
        let y : CGFloat = -3000
        let radius : CGFloat = abs(y)+190
        let startAngle = CGFloat(Double.pi)/2 - asin((rect.width/2)/radius)
        let endAngle = CGFloat(Double.pi)/2 + asin((rect.width/2)/radius)
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = 1.0
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.fill()
    }
}
