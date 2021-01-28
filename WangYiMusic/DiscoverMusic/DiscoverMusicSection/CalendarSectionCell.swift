//
//  CalendarSectionCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/23.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

class CalendarSectionCell: UITableViewCell {
    let rightImageView = UIImageView()
//    let timeLabel = UILabel()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.rightImageView)
//        self.addSubview(self.timeLabel)
        
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        self.textLabel?.font = UIFont.systemFont(ofSize: 12)
        self.textLabel?.textColor = UIColor.lightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rightImageView.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(10)
            m.bottom.equalToSuperview().offset(-10)
            m.right.equalToSuperview().offset(-15)
            m.width.equalTo(self.rightImageView.snp.height)
        }
        self.rightImageView.cornersRound(radius: 8)
    }
}

