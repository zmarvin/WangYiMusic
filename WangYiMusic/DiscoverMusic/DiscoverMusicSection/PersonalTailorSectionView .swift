//
//  PersonalTailorSectionView .swift
//  testSwift
//
//  Created by mac on 2020/12/22.
//

import Foundation
import UIKit

protocol PersonalTailorSectionViewDelegate {
    func personalTailor(sectionCell: PersonalTailorSectionCell, atInnerIndexPath: IndexPath)
    func personalTailor(didSelectRowAt indexPath: IndexPath)
}

class PersonalTailorSectionView :  UIView{
    var myDelegate :PersonalTailorSectionViewDelegate?{
        didSet{
            scrollViewView.myDelegate = myDelegate
        }
    }
    fileprivate let scrollViewView : PersonalTailorSectionInnerScrollView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        scrollViewView = PersonalTailorSectionInnerScrollView(frame: CGRect(x: 0, y: 0, width: frame.width - 50, height: frame.height-20))
        super.init(frame: frame)
        self.addSubview(scrollViewView)
//        self.backgroundColor = UIColor.clear
    }
    
    func reloadData()  {
        self.scrollViewView.reloadData()
        self.scrollViewView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

fileprivate class PersonalTailorSectionInnerScrollView :  UIScrollView,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate{

    fileprivate var myDelegate :PersonalTailorSectionViewDelegate?
    let PersonalTailorIdentifier = "PersonalTailor"
    var tableViews = [UITableView]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpTableViewNum(num: 4)
        self.isPagingEnabled = true
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        subviewsIsHidden()
    }

    func setUpTableViewNum(num:Int) {
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
            view.register(PersonalTailorSectionCell.self, forCellReuseIdentifier: PersonalTailorIdentifier)
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
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "c,mznv,cvn.m"
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
//        return self.myDelegate?.personalTailor(numberOfItemsInSection: tableView.tag) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalTailorIdentifier, for: indexPath) as! PersonalTailorSectionCell
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.personalTailor(sectionCell: cell, atInnerIndexPath: vIndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.myDelegate?.personalTailor(didSelectRowAt: vIndexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/3
    }
    
    func reloadData() {
        for tableView in self.tableViews {
            tableView.reloadData()
        }
    }
}
