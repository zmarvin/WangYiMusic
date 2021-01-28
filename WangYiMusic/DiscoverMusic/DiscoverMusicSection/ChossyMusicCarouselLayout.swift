//
//  ChoosyMusicCarouselLayout.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/1.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class ChoosyMusicCarouselLayout: UICollectionViewLayout {

    var viewWidth : CGFloat = 0
    var itemWidth : CGFloat = 0
    var itemSize : CGSize = .zero
    var visibleCount = 5
    
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
        let cX = collectionView.contentOffset.x + viewWidth / 2
        let attributesX = itemWidth*CGFloat(indexPath.row) + itemWidth/2
        attributes.zIndex = Int(-abs(attributesX - cX))

        let delta : CGFloat = cX - attributesX
        let ratio = -delta/(itemWidth*2)
        let scale = 1 - abs(delta)/(itemWidth*10) * cos(ratio*CGFloat(Double.pi / 4))
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        var centerX = attributesX
        centerX = cX + sin(ratio*CGFloat(Double.pi / 4)) * itemWidth * 0.9
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
