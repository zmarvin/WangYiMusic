//
//  self .swift
//  testSwift
//
//  Created by mac on 2020/12/21.
//

import Foundation
import UIKit

protocol RankingListSectionViewDelegate {
    func rankingList(sectionCell: RankingListSectionCell, atInnerIndexPath: IndexPath)
    func rankingList(didSelectRowAt indexPath: IndexPath)
//    func rankingList(numberOfItemsInInnerSection virtualSection: Int) -> Int
    func rankingList(titleForHeaderInInnerSection section: Int) -> String?
}

class RankingListSectionView :  UIView{
    var myDelegate :RankingListSectionViewDelegate?{
        didSet{
            scrollViewView.myDelegate = myDelegate
        }
    }
    fileprivate let scrollViewView : RankingListSectionInnerScrollView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        scrollViewView = RankingListSectionInnerScrollView(frame: CGRect(x: 0, y: 10, width: frame.width - 50, height: frame.height-30))
        super.init(frame: frame)
        self.addSubview(scrollViewView)
    }
}

fileprivate class RankingListSectionInnerScrollView :  UIScrollView, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    fileprivate var myDelegate :RankingListSectionViewDelegate?
    let rankingListIdentifier = NSStringFromClass(RankingListSectionInnerScrollView.self)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 创建子VIEW
        self.setUpTableViewNum(num: 5)
        self.contentSize = CGSize(width: 5*self.frame.width, height: self.bounds.height)
        self.isPagingEnabled = true
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        subviewsIsHidden()
    }

    func setUpTableViewNum(num:Int) {
        // 创建子VIEW
        let margin :CGFloat = 10.0
        let width = self.frame.width - margin
        let height = self.frame.height
        for i in 0..<num {
            let view = UITableView()
            view.dataSource = self
            view.delegate = self
            view.register(RankingListSectionCell.self, forCellReuseIdentifier: rankingListIdentifier)
            view.tableFooterView = UIView()
            view.layer.cornerRadius = 5
            view.isScrollEnabled = false
            view.separatorStyle = .none
            view.tag = i // 传递虚拟secton
            self.addSubview(view)
            view.frame = CGRect(x: self.frame.width*CGFloat(i)+margin, y: 0, width: width, height: height)
        }
        self.contentSize = CGSize(width: width*CGFloat(num), height: height)
    }
    
    func subviewsIsHidden() {
        let screenRightEdge = WY_SCREEN_WIDTH + self.contentOffset.x
        let screenLeftEdge = self.contentOffset.x
        self.subviews.forEach { (view) in
            view.isHidden = view.frame.minX > screenRightEdge || view.frame.maxX < screenLeftEdge
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.subviews.forEach { (view) in
            view.isHidden = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            subviewsIsHidden()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        subviewsIsHidden()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 200))
        titleLabel.text = self.myDelegate?.rankingList(titleForHeaderInInnerSection: tableView.tag)
        titleLabel.textAlignment = .center
        return titleLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.myDelegate?.rankingList(numberOfItemsInInnerSection: tableView.tag) ?? 0
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rankingListIdentifier, for: indexPath) as! RankingListSectionCell
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.rankingList(sectionCell: cell, atInnerIndexPath: vIndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.rankingList(didSelectRowAt: vIndexPath)
    }
}

/*
class RankingListSectionView :  UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource{
    var myDelegate :RankingListSectionViewDelegate?
    let identifier = NSStringFromClass(RankingListSectionView.self)
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        let margin :CGFloat = 10.0
        let width = frame.width - margin
        let height = frame.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        super.init(frame:frame,collectionViewLayout:layout)
        self.showsHorizontalScrollIndicator = false
        self.register(RankingListInnerCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        self.isPagingEnabled = true
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RankingListInnerCollectionViewCell
        cell.innerSection = indexPath.item
        cell.myDelegate = self.myDelegate
        return cell
    }
    
}

class RankingListInnerCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 200))
        titleLabel.text = self.myDelegate?.rankingList(titleForHeaderInInnerSection: self.innerSection)
        titleLabel.textAlignment = .center
        return titleLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RankingListSectionCell
        let vIndexPath = IndexPath(row: indexPath.row, section: self.innerSection)
        self.myDelegate?.rankingList(sectionCell: cell, atInnerIndexPath: vIndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vIndexPath = IndexPath(row: indexPath.row, section: self.innerSection)
        self.myDelegate?.rankingList(didSelectRowAt: vIndexPath)
    }
    
    let identifier = NSStringFromClass(RankingListInnerCollectionViewCell.self)
    fileprivate var myDelegate :RankingListSectionViewDelegate?
    var innerSection : Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RankingListSectionCell.self, forCellReuseIdentifier: identifier)
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.frame = self.bounds
        self.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
