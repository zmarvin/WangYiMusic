//
//  PersonalTailorSectionCell.swift
//  testSwift
//
//  Created by mac on 2020/12/22.
//

import Foundation
import UIKit

class PersonalTailorSectionCell: UITableViewCell {
    let playBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.imageView?.addSubview(self.playBtn)
        self.playBtn.setImage(UIImage(named: "cm2_vehicle_btn_play"), for: .normal)
        self.imageView?.layer.cornerRadius = 8
        self.imageView?.layer.masksToBounds = true
        
        guard let imageV = self.imageView else{return}
        imageV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(imageV.snp_height)
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.textLabel?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(imageV.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
