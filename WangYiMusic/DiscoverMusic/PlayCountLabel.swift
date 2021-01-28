//
//  PlayCountLabel.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayCountLabel: UIView {
    let contentLabel = UILabel()
    let costomFont = UIFont.systemFont(ofSize: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.gray.cgColor

        self.contentLabel.font = costomFont
        self.contentLabel.textAlignment = .center
        
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let backgroundEffectView = UIVisualEffectView(effect: effect)
        backgroundEffectView.frame = self.bounds
        self.addSubview(backgroundEffectView)
        backgroundEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundEffectView.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var textColor : UIColor?{
        didSet{
            self.contentLabel.textColor = textColor
        }
    }
    
    var text: String?{
        didSet{
            
            guard var t = text, t.count > 0 ,Int(t) != 0 else { return }
            if !t.hasPrefix("▷") { // 如果cell非reuse
                if t.count <= 4{
                    t = "▷" + t
                    text = t
                }
                
                if t.count > 4 && t.count < 9{
                    let index = t.index(t.endIndex, offsetBy: -4)
                    let subT = t[t.startIndex..<index]
                    t = "▷" + subT + "万"
                    text = t
                }
                
                if t.count > 8 {
                    let index = t.index(t.endIndex, offsetBy: -8)
                    let subT = t[t.startIndex..<index]
                    t = "▷" + subT + "亿"
                    text = t
                }
            }

            let attrs = [NSAttributedString.Key.font : costomFont]
            let size = t.boundingRect(with: CGSize(width: 200, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
//            self.bounds = CGRect(x: 0, y: 0, width: size.width+10, height: size.height+2)
            if self.superview != nil {
                self.snp.updateConstraints { (make) in
                    make.width.equalTo(size.width+10)
                    make.height.equalTo(size.height+2)
                }
            }
            self.contentLabel.text = text
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
