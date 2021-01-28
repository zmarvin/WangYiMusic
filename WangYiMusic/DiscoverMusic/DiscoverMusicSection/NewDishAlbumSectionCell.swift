//
//  NewDishAlbumSectionCell.swift
//  testSwift
//
//  Created by mac on 2020/12/22.
//

import Foundation
import UIKit

class NewDishAlbumSectionCell: UITableViewCell {

    let playBtn = UIButton()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.imageView?.addSubview(self.playBtn)
        self.playBtn.setImage(UIImage(named: "cm2_vehicle_btn_play"), for: .normal)
        self.imageView?.layer.cornerRadius = 8
        self.imageView?.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageV = self.imageView else { return }
        imageV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(imageV.snp_height)
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        guard let textLabelF = self.textLabel?.frame else { return }
        self.textLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(imageV.snp.right).offset(10)
            make.top.equalTo(textLabelF.origin.y)
            make.height.equalTo(textLabelF.height)
            make.width.equalTo(textLabelF.width)
        })
        guard let detailTextLabelF = self.detailTextLabel?.frame else { return }
        self.detailTextLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(imageV.snp.right).offset(10)
            make.top.equalTo(detailTextLabelF.origin.y)
            make.height.equalTo(detailTextLabelF.height)
            make.width.equalTo(detailTextLabelF.width)
        })        
    }
        
}
