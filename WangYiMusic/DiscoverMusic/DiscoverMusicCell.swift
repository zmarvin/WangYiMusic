//
//  DiscoverMusicCell.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

enum DiscoverMusicSectionCellType{
    case recommendMusicCell(InnerCollectionViewCell)
    case new_songCell(InnerCollectionViewCell)
    case djprogramCollectionCell(InnerCollectionViewCell) // 播客合辑
    case mvCollectionCell(InnerCollectionViewCell) // 视频合辑
    case recommendMVCell(ChoosyMusicMVSectionCell)
    case recommendDjprogramCell(DjprogramSectionCell) //24小时播客
    case calendarCell(CalendarSectionCell)
    case rankingListCell(RankingListSectionCell)
    case personalTailorCell(PersonalTailorSectionCell)
    case newDishAlbumCell(NewDishAlbumSectionCell)
    case yuncunKTVCell(YuncunKTVSectionCell)
    case voiceLiveCell(InnerCollectionViewCell)
}

protocol DiscoverMusicCellDelegate {
    
    func discoverMusicCell(numberOfItemsInSection virtualSection: Int) -> Int
    func discoverMusicCell(type: DiscoverMusicSectionCellType,at virtualIndexPath: IndexPath)
    func discoverMusicCell(didSelectItemAt virtualIndexPath: IndexPath)
    func discoverMusicCell(heightForRowAt virtualIndexPath: IndexPath) -> CGFloat
    func discoverMusicCell(swipeLeftLoadMore AtVirtualSection: Int)
    
    func discoverMusicCell(rankingListType: DiscoverMusicSectionCellType,atInnerIndexPath: IndexPath,atOuterIndexPath: IndexPath)
    func discoverMusicCell(rankingListTitleForHeaderInInnerSection section: Int,atOuterIndexPath: IndexPath) -> String?
    func discoverMusicCell(rankingListDidSelectItemAt atInnerIndexPath: IndexPath,atOuterIndexPath: IndexPath)
    
    func discoverMusicCell(personalTailor: DiscoverMusicSectionCellType,outSection: Int,middleRandomSection: Int,innerSection:Int,row:Int)
    func discoverMusicCell(personalTailorDidSelectRowAt outSection: Int,middleRandomSection: Int,innerSection:Int,row:Int)
    
    func discoverMusicCell(newDishAlbumUpCell: NewDishAlbumSectionCell,outSection: Int,middleSection: Int,innerSection:Int,row:Int)
    func discoverMusicCell(newDishAlbumUpDidSelectRowAt outSection: Int,middleSection: Int,innerSection:Int,row:Int)
    func discoverMusicCell(newDishAlbumDownCell: NewDishAlbumSectionCell,outSection: Int,middleSection: Int,innerSection:Int,row:Int)
    func discoverMusicCell(newDishAlbumDownDidSelectRowAt outSection: Int,middleSection: Int,innerSection:Int,row:Int)
    
    func discoverMusicCell(calendarCell: CalendarSectionCell, atVirtualIndexPath: IndexPath)
    func discoverMusicCell(calendarDidSelectRowAt indexPath: IndexPath)
    
    func discoverMusicCell_choosyMusicMV(numberOfItemsInSection virtualSection: Int) -> Int
    func discoverMusicCell_choosyMusicMV(cell: ChoosyMusicMVSectionCell, at virtualIndexPath: IndexPath)
    func discoverMusicCell_choosyMusicMV(didSelectRowAt virtualIndexPath: IndexPath)
}
// TODO: 设想，未使用
struct PersonalTailorIndexPath {
    var outSection: Int
    var middleSection: Int
    var innerSection: Int
    var row: Int
}

class DiscoverMusicCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate, RankingListSectionViewDelegate, PersonalTailorSectionViewDelegate, NewDishAlbumSectionViewDelegate, CalendarSectionViewDelegate, ChoosyMusicMVDelegate{

    var personalTailorMiddleSection = Int(arc4random_uniform(4))
    var newDishAlbumUpMiddleSection = 0
    
    var innerView : UIView?
    var myVirtualSection : Int = 0
    var myDelegate : DiscoverMusicCellDelegate?
    
    lazy var djprogramSectionView : DjprogramSectionView = { // 24小时播客

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 60)/3 
        let itemHeight = sectionType.sectionHeight - 20
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let djprogramSectionView = DjprogramSectionView(frame: CGRect.zero, collectionViewLayout: layout)
        djprogramSectionView.register(DjprogramSectionCell.self, forCellWithReuseIdentifier: sectionType.rawValue)
        djprogramSectionView.dataSource = self
        djprogramSectionView.delegate = self
        djprogramSectionView.backgroundColor = UIColor.white
        djprogramSectionView.showsHorizontalScrollIndicator = false

        return djprogramSectionView
    }()
    
    lazy var yuncunKTVCollectionView : UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 60)/3
        let itemHeight = sectionType.sectionHeight - 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = YuncunKTVSectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(YuncunKTVSectionCell.self, forCellWithReuseIdentifier: sectionType.rawValue)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    
    lazy var collectionView : UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 60)/3
        let itemHeight = sectionType.sectionHeight - 20
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = RecommendCollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.register(InnerCollectionViewCell.self, forCellWithReuseIdentifier: sectionType.rawValue)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    lazy var calendarTableVIew : CalendarSectionView = {
        let calendarSectionView = CalendarSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionType.sectionHeight), forCellReuseIdentifier: self.sectionType.rawValue)
        
        calendarSectionView.myDelegate = self
        return calendarSectionView
    }()
    lazy var mVSectionView : ChoosyMusicMVSectionView = {
        let mVSectionView = ChoosyMusicMVSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionType.sectionHeight),reuseIdentifier: self.sectionType.rawValue)
        
        mVSectionView.myDelegate = self
        mVSectionView.backgroundColor = UIColor.white
        return mVSectionView
    }()
    lazy var rankingListSectionView : RankingListSectionView = {
        let rankingListSectionView = RankingListSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionType.sectionHeight))
        rankingListSectionView.myDelegate = self
        rankingListSectionView.backgroundColor = UIColor(red: 250/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        return rankingListSectionView
    }()
    lazy var personalTailorSectionView : PersonalTailorSectionView = {
        let personalTailorSectionView = PersonalTailorSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionType.sectionHeight))
        personalTailorSectionView.myDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPersonalTailor), name: Notification.Name("personalTailorMiddleRandomSection"), object: nil)
        return personalTailorSectionView
    }()
    lazy var newDishAlbumSectionView : NewDishAlbumSectionView = {
        let newDishAlbumSectionView = NewDishAlbumSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionType.sectionHeight))
        newDishAlbumSectionView.myDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewDishAlbumWithSectionNum), name: Notification.Name("reloadNewDishAlbumWithSectionNum"), object: nil)
        return newDishAlbumSectionView
    }()
    // 通知：reloadNewDishAlbumWithSectionNum 回调方法
    @objc func reloadNewDishAlbumWithSectionNum(noti:NSNotification) {
        if let sectionNum = noti.object as? Int {
            self.newDishAlbumUpMiddleSection = sectionNum
            var innerTableViewNum = 2
            switch sectionNum {
            case 0...1://表示是 新歌或新碟，需要2个innerTableView
                innerTableViewNum = 2
            case 2://表示是 数字专辑，需要3个innerTableView
                innerTableViewNum = 3
            default:break
            }
            self.newDishAlbumSectionView.reloadData_AND_refreshUpTableViewNum(num: innerTableViewNum)
        }
    }
    // 通知：personalTailorMiddleRandomSection 回调方法
    @objc func reloadPersonalTailor() {
        func randomDifferent()->Int{
            let a = Int(arc4random_uniform(4))
            if self.personalTailorMiddleSection == a {
                return randomDifferent()
            }else{
                return a
            }
        }
        self.personalTailorMiddleSection = randomDifferent()
        self.personalTailorSectionView.reloadData()
    }
    var sectionType : DiscoverMusicSectionType = .recommendMusic{
        didSet{
            switch sectionType {
            case .voiceLive:fallthrough
            case .mvCollection:fallthrough
            case .recommendMusic:fallthrough
            case .djprogramCollection:fallthrough
            case .new_song:
                self.contentView.addSubview(self.collectionView)
                innerView = self.collectionView
            case .recommendMV:
                self.contentView.addSubview(self.mVSectionView)
                innerView = self.mVSectionView
            case .recommendDjprogram:
                self.contentView.addSubview(self.djprogramSectionView)
                innerView = self.djprogramSectionView
            case .calendar:
                self.contentView.addSubview(self.calendarTableVIew)
                innerView = self.calendarTableVIew
            case .rankingList:
                self.contentView.addSubview(self.rankingListSectionView)
                innerView = self.calendarTableVIew
            case .personalTailor:
                self.contentView.addSubview(self.personalTailorSectionView)
                innerView = self.personalTailorSectionView
            case .newDishAlbum:
                self.contentView.addSubview(self.newDishAlbumSectionView)
                innerView = self.newDishAlbumSectionView
            case .yuncunKTV:
                self.contentView.addSubview(self.yuncunKTVCollectionView)
                innerView = self.yuncunKTVCollectionView
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerView?.frame = self.bounds
    }
    
    // MARK: -- NewDishAlbumSectionViewDelegate
    func newDishAlbumUp(cell: NewDishAlbumSectionCell, cellForRowAt indexPath: IndexPath) {
        self.myDelegate?.discoverMusicCell(newDishAlbumUpCell: cell, outSection: self.myVirtualSection, middleSection: self.newDishAlbumUpMiddleSection, innerSection: indexPath.section, row: indexPath.row)
    }
    func newDishAlbumUp(didSelectRowAt indexPath: IndexPath) {
        self.myDelegate?.discoverMusicCell(newDishAlbumUpDidSelectRowAt: self.myVirtualSection, middleSection: self.newDishAlbumUpMiddleSection, innerSection: indexPath.section, row: indexPath.row)
    }
    func newDishAlbumDown(cell: NewDishAlbumSectionCell, cellForRowAt indexPath: IndexPath) {
        #warning("middleSection:为3，是获取modol数组的最后一个")
        self.myDelegate?.discoverMusicCell(newDishAlbumDownCell: cell, outSection: self.myVirtualSection, middleSection: 3, innerSection: indexPath.section, row: indexPath.row)
    }
    func newDishAlbumDown(didSelectRowAt indexPath: IndexPath) {
        self.myDelegate?.discoverMusicCell(newDishAlbumDownDidSelectRowAt: self.myVirtualSection, middleSection: 3, innerSection: indexPath.section, row: indexPath.row)
    }
    
    // MARK: -- PersonalTailorSectionViewDelegate
    func personalTailor(sectionCell: PersonalTailorSectionCell, atInnerIndexPath: IndexPath) {
        self.myDelegate?.discoverMusicCell(personalTailor: .personalTailorCell(sectionCell), outSection: self.myVirtualSection, middleRandomSection: self.personalTailorMiddleSection, innerSection: atInnerIndexPath.section, row: atInnerIndexPath.row)
    }
    func personalTailor(didSelectRowAt indexPath: IndexPath) {
        self.myDelegate?.discoverMusicCell(personalTailorDidSelectRowAt: self.myVirtualSection, middleRandomSection: self.personalTailorMiddleSection, innerSection: indexPath.section, row: indexPath.row)
    }
    
    // MARK: -- RankingListSectionInnerScrollViewDelegate
    func rankingList(sectionCell: RankingListSectionCell, atInnerIndexPath: IndexPath) {
        let outerIndexPath = IndexPath(row: atInnerIndexPath.section, section: self.myVirtualSection)
        
        self.myDelegate?.discoverMusicCell(rankingListType: .rankingListCell(sectionCell), atInnerIndexPath: atInnerIndexPath, atOuterIndexPath: outerIndexPath)
    }
    func rankingList(didSelectRowAt indexPath: IndexPath) {
        let outerIndexPath = IndexPath(row: indexPath.section, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell(rankingListDidSelectItemAt: indexPath, atOuterIndexPath: outerIndexPath)
    }
    func rankingList(titleForHeaderInInnerSection section: Int) -> String? {
        let outerIndexPath = IndexPath(row: section, section: self.myVirtualSection)
        return self.myDelegate?.discoverMusicCell(rankingListTitleForHeaderInInnerSection: section, atOuterIndexPath: outerIndexPath)
    }
    // MARK: -- CalendarSectionViewDelegate
    func calendar(cell: CalendarSectionCell, at indexPath: IndexPath) {
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell(calendarCell: cell, atVirtualIndexPath: virtualIndexPath)
    }
    
    func calendar(didSelectRowAt indexPath: IndexPath) {
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell(calendarDidSelectRowAt: virtualIndexPath)
    }
    // MARK: -- ChoosyMusicMVDelegate
    func choosyMusicMV(numberOfItemsInSection section: Int) -> Int {
        return self.myDelegate?.discoverMusicCell_choosyMusicMV(numberOfItemsInSection: self.myVirtualSection) ?? 0
    }
    
    func choosyMusicMV(cell: ChoosyMusicMVSectionCell, cellForRowAt indexPath: IndexPath) {
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell_choosyMusicMV(cell: cell, at: virtualIndexPath)
    }
    
    func choosyMusicMV(didSelectRowAt indexPath: IndexPath) {
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell_choosyMusicMV(didSelectRowAt: virtualIndexPath)
    }

    // MARK:UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myDelegate?.discoverMusicCell(numberOfItemsInSection: self.myVirtualSection) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sectionType.rawValue, for: indexPath)
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        
        var cellType : DiscoverMusicSectionCellType
        
        switch self.sectionType {
        case .djprogramCollection:
            cellType = .djprogramCollectionCell(cell as! InnerCollectionViewCell)
        case .mvCollection:
            cellType = .mvCollectionCell(cell as! InnerCollectionViewCell)
        case .recommendMusic:
            cellType = .recommendMusicCell(cell as! InnerCollectionViewCell)
        case .new_song:
            cellType = .new_songCell(cell as! InnerCollectionViewCell)
        case .recommendDjprogram:
            cellType = .recommendDjprogramCell(cell as! DjprogramSectionCell)
        case .recommendMV:
            cellType = .recommendMVCell(cell as! ChoosyMusicMVSectionCell)
        case .yuncunKTV:
            cellType = .yuncunKTVCell(cell as! YuncunKTVSectionCell)
        case .calendar:
            cellType = .calendarCell(cell as! CalendarSectionCell)
        case .rankingList:
            cellType = .rankingListCell(cell as! RankingListSectionCell)
        case .personalTailor:
            cellType = .personalTailorCell(cell as! PersonalTailorSectionCell)
        case .newDishAlbum:
            cellType = .newDishAlbumCell(cell as! NewDishAlbumSectionCell)
        case .yuncunKTV:
            cellType = .yuncunKTVCell(cell as! YuncunKTVSectionCell)
        case .voiceLive:
            cellType = .voiceLiveCell(cell as! InnerCollectionViewCell)
        }
        
        self.myDelegate?.discoverMusicCell(type: cellType, at: virtualIndexPath)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let virtualIndexPath = IndexPath(row: indexPath.row, section: self.myVirtualSection)
        self.myDelegate?.discoverMusicCell(didSelectItemAt: virtualIndexPath)
    }
    
    // MARK:UIScrollViewDelegate 监控collectionView左滑到右边界，触发事件
    var isTriggerSwipeLeftLoadMore = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentoffsetX = scrollView.contentSize.width - scrollView.contentOffset.x
        if contentoffsetX < (scrollView.bounds.width - leftGlideRefreshMoreViewWidth) {
            if self.isTriggerSwipeLeftLoadMore {
                return
            }
            self.isTriggerSwipeLeftLoadMore = true
            self.myDelegate?.discoverMusicCell(swipeLeftLoadMore: self.myVirtualSection)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isTriggerSwipeLeftLoadMore = false
    }
    
}



