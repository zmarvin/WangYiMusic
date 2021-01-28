//
//  SearchCollectionViewCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class SearchCollectionViewCell: UICollectionViewCell {

    let indexLabel = UILabel()
    let iconImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let iconImageViewW :CGFloat = 30
    private let titleLabelMargin :CGFloat = 10
    private let indexLabelW:CGFloat = 50
    
    var title : String = ""{
        didSet{
            titleLabel.text = title
            //更新约束
            let attrs = [NSAttributedString.Key.font : titleLabel.font]
            var titleW = title.boundingRect(with: CGSize(width: 200, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil).width
            
            let titleMaxW = self.frame.width - (indexLabelW+titleLabelMargin+iconImageViewW)
            if titleW > titleMaxW {
                titleW = titleMaxW
            }
            titleLabel.snp.updateConstraints { (make) in
                make.left.equalTo(indexLabel.snp.right)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(titleW+titleLabelMargin)
            }
            iconImageView.snp.updateConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right)
                make.height.equalTo(15)
                make.width.equalTo(iconImageViewW)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(indexLabel)
        self.addSubview(titleLabel)
        self.addSubview(iconImageView)

        iconImageView.contentMode = .scaleAspectFit
        indexLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        indexLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(indexLabelW)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        iconImageView.snp.updateConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.height.equalTo(15)
            make.width.equalTo(iconImageViewW)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension String{
    func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let attritube = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attritube.length)
        attritube.addAttributes([NSAttributedString.Key.font : font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            attritube.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size
        
        if let currentLineSpacing = lineSpacing {
            // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }
        
        return size
    }
}
