//
//  RankingListSectionCell.swift
//  testSwift
//
//  Created by mac on 2020/12/21.
//

import Foundation
import UIKit

class RankingListSectionCell: UITableViewCell {
    let indexLabel = UILabel()
    let playBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.imageView?.layer.cornerRadius = 8
        self.imageView?.layer.masksToBounds = true
        self.addSubview(self.indexLabel)
        self.indexLabel.textAlignment = .center
        self.imageView?.addSubview(self.playBtn)
        self.playBtn.setImage(UIImage(named: "cm2_vehicle_btn_play"), for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
 
        if let imageV = self.imageView {
            imageV.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(5)
                make.bottom.equalToSuperview().offset(-5)
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(imageV.snp_height)
            }
            
            imageV.cornersRound(radius: 8)
            indexLabel.snp.makeConstraints { (make) in
                make.left.equalTo(imageV.snp.right).offset(5)
                make.centerY.equalTo(imageV.snp.centerY)
                make.width.height.equalTo(30)
            }
            
            if let textLabel = self.textLabel {
                let tempF = textLabel.frame
                textLabel.frame = CGRect(x: tempF.origin.x - 20, y: tempF.origin.y, width: tempF.width, height: tempF.height)
                textLabel.snp.removeConstraints()
                textLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(tempF.origin.y)
                    make.width.equalTo(tempF.width)
                    make.height.equalTo(tempF.height)
                    make.left.equalTo(indexLabel.snp.right).offset(5)
                }
            }
            
            playBtn.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }

        

    }
}
