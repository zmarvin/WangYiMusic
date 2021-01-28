//
//  PlayListPlazaCarouselLayout.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListPlazaCarouselLayout: UICollectionViewLayout {
    private var adjustCellEachDistanceRatio : CGFloat = 1.5
    private var viewWidth : CGFloat = 0
    private var itemWidth : CGFloat = 0
    var itemSize : CGSize = .zero
    private var visibleCount = 3
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        viewWidth = collectionView.frame.width
        itemWidth = self.itemSize.width
        collectionView.contentInset = UIEdgeInsets(top: 0, left: (viewWidth-itemWidth)/2, bottom: 0, right: (viewWidth-itemWidth)/2)
    }
    
    override var collectionViewContentSize: CGSize{
        guard let collectionView = self.collectionView else { return .zero}
        let cellCount = collectionView.numberOfItems(inSection: 0)
        return CGSize(width: CGFloat(cellCount)*itemWidth, height: collectionView.frame.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil}
        let cellCount = collectionView.numberOfItems(inSection: 0)
        guard cellCount > 0 else { return nil}
        let centerX = collectionView.contentOffset.x + viewWidth/2
        
        let index  = Int(centerX/itemWidth)
        let num = (self.visibleCount - 1)/2
        let minIndex = max(0, index - num)
        let maxIndex = min(cellCount - 1, index + num)
        var arr = [UICollectionViewLayoutAttributes]()
        for i in minIndex...maxIndex {
            if let attributes = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0)){
                arr.append(attributes)
            }
        }
        
        return arr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil}
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = self.itemSize
        let viewCenterX = collectionView.contentOffset.x + viewWidth / 2
        let itemCenterX = itemWidth*CGFloat(indexPath.row) + itemWidth/2
        attributes.zIndex = Int(-abs(itemCenterX - viewCenterX))

        let delta : CGFloat = viewCenterX - itemCenterX
        let ratio = -delta/(itemWidth*2)
        let scale = 1 - abs(delta)/(itemWidth*7) * cos(ratio*CGFloat(Double.pi / 4))
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let centerX = viewCenterX + sin(ratio*CGFloat(Double.pi / 4)) * itemWidth * adjustCellEachDistanceRatio
        attributes.center = CGPoint(x: centerX, y: collectionView.frame.height/2)
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pX = Float(proposedContentOffset.x + viewWidth/2 - itemWidth/2)
        let index = CGFloat(roundf(pX/Float(itemWidth)))
        let x = itemWidth*index + itemWidth/2 - viewWidth/2
        let point = CGPoint(x: x, y: proposedContentOffset.y)
        return point
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { return false}
        return newBounds.width == collectionView.bounds.width && newBounds.height == collectionView.bounds.height
    }
}
