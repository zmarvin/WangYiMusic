//
//  MusicPlayDiscCollectionView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/18.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import Kingfisher

let MusicPlayDiscToScreenW_Ratio : CGFloat = 350/390.0
class MusicPlayDiscCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var imageUrls : [String]?{
        didSet{
            self.reloadData()
        }
    }
    
    func setCurrentIndex(index: Int,animated: Bool){
        guard self.currentIndex != index else {return}
        self.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: animated)
        self.currentIndex = index
    }
    
    private var currentIndex : Int = 0{
        didSet{
            if self.currentIndex != oldValue {
                pauseAnimationAt(index: oldValue)
            }
        }
    }
    
    var currentCell : MusicPlayDiscCollectionViewCell?{
        return self.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? MusicPlayDiscCollectionViewCell
    }
    
    var scrollSelectItemCallBack : ((Int) -> Void)?

    func pauseAnimation() {
        pauseAnimationAt(index: currentIndex)
    }
    
    func startAnimation() {
        guard let currentCell = self.currentCell else { return }
        currentCell.resumeAnimation()
    }
    
    private func pauseAnimationAt(index:Int) {
        if let cell = self.cellForItem(at: IndexPath(item: index, section: 0)) as? MusicPlayDiscCollectionViewCell {
            cell.pauseAnimation()
        }
    }
    
    private let identif = NSStringFromClass(MusicPlayDiscCollectionView.self)
    init() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = WY_SCREEN_WIDTH * MusicPlayDiscToScreenW_Ratio
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = WY_SCREEN_WIDTH - itemWidth
        layout.minimumInteritemSpacing = 0
        let leftInset = (WY_SCREEN_WIDTH - itemWidth)/2
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.register(MusicPlayDiscCollectionViewCell.self, forCellWithReuseIdentifier: identif)
        self.backgroundColor = .white
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identif, for: indexPath) as! MusicPlayDiscCollectionViewCell
        if let url = self.imageUrls?[indexPath.row] {
            cell.picView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "em_play_default_cover"))
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        print("当前index：\(index)")
        self.scrollSelectItemCallBack?(index)
        self.currentIndex = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = initializeDiscCollectionViewCurrentIndex
    }
    
    lazy var initializeDiscCollectionViewCurrentIndex: Void = {
        self.contentOffset.x = CGFloat(currentIndex) * self.bounds.size.width
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.imageUrls?.forEach({ (url) in
//            ImageCache.default.removeImage(forKey: url)
        })
    }
}

