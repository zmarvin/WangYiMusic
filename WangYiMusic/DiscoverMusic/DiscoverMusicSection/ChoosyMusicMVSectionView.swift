//
//  DiscoverMusicMVSectionView.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/22.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

protocol ChoosyMusicMVDelegate : class {
    func choosyMusicMV(numberOfItemsInSection section: Int) -> Int
    func choosyMusicMV(cell: ChoosyMusicMVSectionCell, cellForRowAt indexPath: IndexPath)
    func choosyMusicMV(didSelectRowAt indexPath: IndexPath)
}

class ChoosyMusicMVSectionView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    weak var myDelegate : ChoosyMusicMVDelegate?
    
    var collectionView : UICollectionView
    var reuseIdentifier : String = "ChoosyMusicMVSectionView"
    var middleCellIndexPath : IndexPath = IndexPath(row: 0 , section: 0)
    
    override init(frame: CGRect) {
        let layout = ChoosyMusicCarouselLayout()
        let itemWidth = (UIScreen.main.bounds.width - 10)/2 - 15
        let itemHeight = frame.height - 30
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: itemHeight), collectionViewLayout: layout)
        
        super.init(frame: frame)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
    }
    convenience init(frame: CGRect,reuseIdentifier: String) {
        
        self.init(frame: frame)
        self.reuseIdentifier = reuseIdentifier
        self.collectionView.register(ChoosyMusicMVSectionCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        self.collectionView.setValue(0.00001, forKeyPath: "_velocityScaleFactor")
        NotificationCenter.default.addObserver(self, selector: #selector(choosyMusicIsPlayMV), name: NSNotification.Name(rawValue: "choosyMusicIsPlayMV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(initializeChoosyMusicMVCell), name: NSNotification.Name(rawValue: "initializeChoosyMusicMVCell"), object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func choosyMusicIsPlayMV(noti:Notification)  {
        // 播放中间cell的视频
        guard let isInScreen = noti.object as? Bool else { return }
        
        guard let cell = self.collectionView.cellForItem(at: self.middleCellIndexPath) as? ChoosyMusicMVSectionCell else {return}
        if isInScreen {
            cell.play()
        }else{
            cell.pause()
        }
    }
    
    @objc func initializeChoosyMusicMVCell() {
        self.scrollViewDidEndDecelerating(self.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ChoosyMusicMVSectionCell
        self.myDelegate?.choosyMusicMV(cell: cell, cellForRowAt: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myDelegate?.choosyMusicMV(numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.myDelegate?.choosyMusicMV(didSelectRowAt: indexPath)
    }
    
    lazy var initializeCollectionViewScrollCenterCell: Void = {
        guard let itemsNum = self.myDelegate?.choosyMusicMV(numberOfItemsInSection: 0) else{return}
        let n : Int = itemsNum/2
        guard let layout = self.collectionView.collectionViewLayout as? ChoosyMusicCarouselLayout else { return }
        let y = self.collectionView.contentOffset.y
        // 模拟无限循环，定位到中间cell
        self.collectionView.setContentOffset(CGPoint(x: layout.itemSize.width*CGFloat(n)+(layout.itemSize.width)/2 - self.collectionView.frame.width*0.5, y: y), animated: false)
    }()
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _ = self.initializeCollectionViewScrollCenterCell
    }
    // MARK: 监控cell到中心位置，触发播放事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let layout = self.collectionView.collectionViewLayout as? ChoosyMusicCarouselLayout else { return }
        let centerCellX = scrollView.contentOffset.x + self.collectionView.frame.width*0.5
        let index : Int = Int(centerCellX / layout.itemSize.width)
        print("精品音乐视频中心Cell在：\(index)")
        let indexPath = IndexPath(row: index, section: 0)
        self.middleCellIndexPath = indexPath
        // 播放当前cell
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? ChoosyMusicMVSectionCell else {return}
        cell.play()
        cell.frostedGlassView.alpha = 0
        
        let leftIndexPath = IndexPath(row: index-1, section: 0)
        guard let leftCell = self.collectionView.cellForItem(at: leftIndexPath) as? ChoosyMusicMVSectionCell else{return}
        let rightIndexPath = IndexPath(row: index+1, section: 0)
        guard let rightCell = self.collectionView.cellForItem(at: rightIndexPath) as? ChoosyMusicMVSectionCell else{return}
        leftCell.frostedGlassView.alpha = 0.5
        rightCell.frostedGlassView.alpha = 0.5
        leftCell.pause()
        rightCell.pause()
//        leftCell.destroyPlayer()
//        rightCell.destroyPlayer()
        
        let left2IndexPath = IndexPath(row: index-2, section: 0)
        guard let left2Cell = self.collectionView.cellForItem(at: left2IndexPath) as? ChoosyMusicMVSectionCell else {return}
        let right2IndexPath = IndexPath(row: index+2, section: 0)
        guard let right2Cell = self.collectionView.cellForItem(at: right2IndexPath) as? ChoosyMusicMVSectionCell else {return}
        left2Cell.frostedGlassView.alpha = 0.9
        right2Cell.frostedGlassView.alpha = 0.9
        left2Cell.pause()
        right2Cell.pause()
//        left2Cell.destroyPlayer()
//        right2Cell.destroyPlayer()
        
        let left3IndexPath = IndexPath(row: index-3, section: 0)
        guard let left3Cell = self.collectionView.cellForItem(at: left3IndexPath) as? ChoosyMusicMVSectionCell else {return}
        let right3IndexPath = IndexPath(row: index+3, section: 0)
        guard let right3Cell = self.collectionView.cellForItem(at: right3IndexPath) as? ChoosyMusicMVSectionCell else {return}
        left3Cell.frostedGlassView.alpha = 1
        right3Cell.frostedGlassView.alpha = 1
        left3Cell.pause()
        right3Cell.pause()
//        left3Cell.destroyPlayer()
//        right3Cell.destroyPlayer()
        /*
        guard let num = self.myDelegate?.choosyMusicMV(numberOfItemsInSection: 0) else{return}
        for i in 0..<num {
            if i == index {continue}
            let otherIndexPath = IndexPath(row: i, section: 0)
            guard let otherCell = self.collectionView.cellForItem(at: otherIndexPath) as? ChoosyMusicMVSectionCell else {continue}
            otherCell.pause()
        }
        */
    }
    
}
