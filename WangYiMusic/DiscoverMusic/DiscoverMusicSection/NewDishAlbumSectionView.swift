//
//  NewDishAlbumSectionView.swift
//  testSwift
//
//  Created by mac on 2020/12/22.
//

import Foundation
import UIKit

protocol NewDishAlbumSectionViewDelegate {
    func newDishAlbumUp(cell: NewDishAlbumSectionCell, cellForRowAt indexPath: IndexPath)
    func newDishAlbumUp(didSelectRowAt indexPath: IndexPath)
    func newDishAlbumDown(cell: NewDishAlbumSectionCell, cellForRowAt indexPath: IndexPath)
    func newDishAlbumDown(didSelectRowAt indexPath: IndexPath)
}

class NewDishAlbumSectionView :  UIView{
    var myDelegate :NewDishAlbumSectionViewDelegate?{
        didSet{
            self.scrollViewUp.myDelegate = myDelegate
            self.scrollViewDown.myDelegate = myDelegate
        }
    }
    fileprivate let scrollViewUp : NewDishAlbumSectionInnerScrollViewUp
    fileprivate let scrollViewDown : NewDishAlbumSectionInnerScrollViewDown
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        
        let labelH : CGFloat = 30
        
        let scrollViewDownH = (frame.height-labelH)*0.25 // 0.25表示竖方向上有4个cell
        let scrollViewUpH = scrollViewDownH*3 - 20// 20为margin
        
        self.scrollViewUp = NewDishAlbumSectionInnerScrollViewUp(frame: CGRect(x: 0, y: 0, width: frame.width - 50, height: scrollViewUpH))
        
        let label = UILabel()
        label.text = "推荐以下新歌 赚双倍云贝"
        label.font = UIFont.systemFont(ofSize: 14)
        let scrollViewMaxY = self.scrollViewUp.frame.maxY
        label.frame = CGRect(x: 15, y: scrollViewMaxY, width: frame.width, height: CGFloat(labelH))
        
        let labelMaxY = label.frame.maxY
        let scrollView2Frame = CGRect(x: 0, y: labelMaxY, width: self.scrollViewUp.frame.width, height: scrollViewDownH)
        self.scrollViewDown = NewDishAlbumSectionInnerScrollViewDown(frame: scrollView2Frame)
        
        super.init(frame: frame)
        
        self.addSubview(self.scrollViewUp)
        self.addSubview(label)
        self.addSubview(self.scrollViewDown)
//        self.backgroundColor = UIColor.clear
    }
    
    func reloadData_AND_refreshUpTableViewNum(num:Int)  {
        self.scrollViewUp.refreshUpTableViewNum(num: num)
        self.scrollViewUp.reloadData()
        self.scrollViewUp.contentOffset = CGPoint(x: 0, y: 0)//复位
    }
}

fileprivate class NewDishAlbumSectionInnerScrollViewUp :  UIScrollView, UIScrollViewDelegate, UITableViewDataSource , UITableViewDelegate{

    func reloadData() {
        for tableView in self.tableViews {
            tableView.reloadData()
        }
    }
    
    func refreshUpTableViewNum(num:Int) {
        if self.subviews.count>0 {
            for subV in self.subviews {
                subV.removeFromSuperview()
            }
            self.tableViews.removeAll()
        }
        // 创建子VIEW
        let width = self.frame.width
        let height = self.frame.height
        for i in 0..<num {
            let view = UITableView()
            view.dataSource = self
            view.delegate = self
            view.register(NewDishAlbumSectionCell.self, forCellReuseIdentifier: NewDishAlbumIdentifier)
            view.tableFooterView = UIView()
            view.tag = i // 传递虚拟secton
            view.isScrollEnabled = false
            view.separatorStyle = .none
            self.addSubview(view)
            self.tableViews.append(view)
            view.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: height)
        }
        self.contentSize = CGSize(width: width*CGFloat(num), height: height)
    }
    
    fileprivate var myDelegate : NewDishAlbumSectionViewDelegate?
    let NewDishAlbumIdentifier = "NewDishAlbumSectionInnerScrollViewUp"
    var tableViews = [UITableView]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshUpTableViewNum(num: 2)
        
        self.isPagingEnabled = true
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        subviewsIsHidden()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
//        return self.myDelegate?.newDishAlbum(numberOfItemsInSection: tableView.tag) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewDishAlbumIdentifier, for: indexPath) as! NewDishAlbumSectionCell
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.newDishAlbumUp(cell: cell, cellForRowAt: vIndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.newDishAlbumUp(didSelectRowAt: vIndexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/3
    }
}

fileprivate class NewDishAlbumSectionInnerScrollViewDown :  UIScrollView,UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vIndexPath = IndexPath(row: tableView.tag, section: 0)
        self.myDelegate?.newDishAlbumDown(didSelectRowAt: vIndexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewDishAlbumIdentifier2, for: indexPath) as! NewDishAlbumSectionCell
        let vIndexPath = IndexPath(row: tableView.tag, section: 0)
        self.myDelegate?.newDishAlbumDown(cell: cell, cellForRowAt: vIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height - 8
    }
    
    fileprivate var myDelegate :NewDishAlbumSectionViewDelegate?
    let NewDishAlbumIdentifier2 = "NewDishAlbumSectionInnerScrollViewDown"
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpDownTableViewNum(num: 3)
        self.isPagingEnabled = true
        self.clipsToBounds = false
//        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
    }
    func setUpDownTableViewNum(num:Int) {
        // 创建子VIEW
        let width = self.frame.width
        let height = self.frame.height
        for i in 0..<num {
            let view = UITableView()
            view.dataSource = self
            view.delegate = self
            view.register(NewDishAlbumSectionCell.self, forCellReuseIdentifier: NewDishAlbumIdentifier2)
            view.tableFooterView = UIView()
            view.tag = i // 传递虚拟secton
            view.isScrollEnabled = false
            view.separatorStyle = .none
            self.addSubview(view)
            
            view.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: height)
        }
        self.contentSize = CGSize(width: width*CGFloat(num), height: height)
    }
}


