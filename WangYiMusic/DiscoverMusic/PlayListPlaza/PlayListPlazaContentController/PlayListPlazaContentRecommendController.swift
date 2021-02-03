//
//  PlayListPlazaContentController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/1.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

protocol PlayListPlazaTopCarouselViewScrollCenterCellObserver : class {
    func playListPlazaContentRecommendControllerTopCarouselViewScrollCenter(cell:PlayListPlazaCarouselCell,model:PlayListPlazaModel,indexPath:IndexPath)
}

class PlayListPlazaContentRecommendController: PlayListPlazaContentBaseController, UICollectionViewDelegate, UICollectionViewDataSource {

    let topCarouselViewHeight : CGFloat = 245
    var topCarouselModels : [PlayListPlazaModel] = [PlayListPlazaModel]()
    var underCollectionModels : [PlayListPlazaModel] = [PlayListPlazaModel]()
    weak var topCarouselViewScrollCenterCellObserver : PlayListPlazaTopCarouselViewScrollCenterCellObserver?
    var topCarouselCenterCellModel : PlayListPlazaModel?
    
    lazy var topCarouselView : UICollectionView = {
        let layout = PlayListPlazaCarouselLayout()
        let itemWidth = UIScreen.main.bounds.width/2 - 15
        let itemHeight = topCarouselViewHeight - 20 // 20 代表item上下间距为10
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.register(PlayListPlazaCarouselCell.self, forCellWithReuseIdentifier: "PlayListPlazaCarouselCell")
        cV.decelerationRate = .fast
        cV.showsHorizontalScrollIndicator = false
        return cV
    }()
    
    lazy var underCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50)/3
        let itemHeight = itemWidth + 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: topCarouselViewHeight)
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.register(PlayListPlazaCommonCell.self, forCellWithReuseIdentifier: "PlayListPlazaCommonCell")
        cV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlayListPlazaSectionHeader")
        return cV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpData()
        self.setUpGesture()
    }
    
    func setUpData() {
        self.underCollectionView.mj_header = MJRefreshGifHeader(refreshingBlock: { [unowned self] in
            API.get_playList(limit:18,cat: nil).subscribe(onSuccess: { models in
                self.dataModels = models
                self.topCarouselModels = (0...2).map{models[$0]}
                self.underCollectionModels = (3..<models.count).map{models[$0]}
                self.topCarouselView.reloadData()
                self.underCollectionView.reloadData()
                self.underCollectionView.mj_header?.endRefreshing()
            }, onFailure: { err in
                self.underCollectionView.mj_header?.endRefreshing()
            }).disposed(by: disposeBag)
        }).config().refresh()
    }
    
    func setUpView() {
        topCarouselView.dataSource = self
        topCarouselView.delegate = self
        topCarouselView.backgroundColor = .white
        
        self.view.addSubview(underCollectionView)
        underCollectionView.delegate = self
        underCollectionView.dataSource = self
        underCollectionView.backgroundColor = .white
        underCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpGesture() {// 解决uiscrollview和系统的返手势冲突
        if let gesture = self.navigationController?.interactivePopGestureRecognizer {
            self.underCollectionView.panGestureRecognizer.require(toFail: gesture)
            self.topCarouselView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case _ where collectionView === topCarouselView:
            return self.topCarouselViewInfinityIndexArr.count
        case _ where collectionView === underCollectionView:
            return self.underCollectionModels.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case _ where collectionView === topCarouselView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListPlazaCarouselCell", for: indexPath) as! PlayListPlazaCarouselCell
            let index = self.topCarouselViewInfinityIndexArr[indexPath.row]
            guard self.topCarouselModels.count > 0 else { return cell }
            let model = self.topCarouselModels[index]
            cell.titleLabel.text = model.name
            cell.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl)) { (image, error, cacheType, url) in
                guard let url = url else {return}
                Self.downloadedReadyRenderImageKeys.append(url)
                Self.downloadedReadyRenderImageKeysSubject.onNext(Self.downloadedReadyRenderImageKeys)
            }
            cell.playCountLabel.text = model.playCount
            return cell
        case _ where collectionView === underCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListPlazaCommonCell" , for: indexPath) as! PlayListPlazaCommonCell
            let model = self.underCollectionModels[indexPath.row]
            cell.titleLabel.text = model.name
            cell.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl))
            cell.playCountLabel.text = model.playCount
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListPlazaCommonCell" , for: indexPath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlayListPlazaSectionHeader", for: indexPath)
        if header.subviews.count == 0 {
            header.addSubview(topCarouselView)
            topCarouselView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model = PlayListPlazaModel()
        switch collectionView {
        case _ where collectionView === topCarouselView:
            let index = self.topCarouselViewInfinityIndexArr[indexPath.row]
            guard self.topCarouselModels.count > 0 else { return }
            model = self.topCarouselModels[index]
        case _ where collectionView === underCollectionView:
            model = self.underCollectionModels[indexPath.row]
        default:break
        }
        let vc = PlayListController(musicId: model.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView === self.topCarouselView {
            _ = self.initializeCellState
        }
    }
    
    // MARK: -- 设置topCarouselView 无限滚动步骤：1，添加300Number；2，滚动到中间
    lazy var topCarouselViewInfinityIndexArr :[Int] = {
        var indexArr = [Int]()
        for _ in 0 ..< 100 { //
            for j in 0 ..< 3 {
                indexArr.append(j)
            }
        }
        return indexArr
    }()
    
    lazy var scrollToCenterCell: Void = {
        let itemsNum = self.topCarouselView.numberOfItems(inSection: 0)
        let n : Int = itemsNum/2
        guard let layout = self.topCarouselView.collectionViewLayout as? PlayListPlazaCarouselLayout else { return }
        let y = self.topCarouselView.contentOffset.y
        // 模拟无限循环，定位到中间cell
        let centerPoint = CGPoint(x: layout.itemSize.width*CGFloat(n)+(layout.itemSize.width)/2 - self.topCarouselView.frame.width*0.5, y: y)
        self.topCarouselView.setContentOffset(centerPoint, animated: false)
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _ = self.scrollToCenterCell
    }
    
    lazy var initializeCellState: Void = {
        self.monitorTopCarouselViewCentreCellIndex()
    }()
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView === self.topCarouselView {
            self.monitorTopCarouselViewCentreCellIndex()
        }
    }
    // MARK: 监控cell到中心位置，触发事件
    func monitorTopCarouselViewCentreCellIndex() {
        guard let layout = self.topCarouselView.collectionViewLayout as? PlayListPlazaCarouselLayout else { return }
        let centerCellX = self.topCarouselView.contentOffset.x + self.topCarouselView.frame.width*0.5
        let index : Int = Int(centerCellX / layout.itemSize.width)
        print("PlayListPlazaTopCarouselViewCell index在：\(index)")
        let indexPath = IndexPath(row: index, section: 0)
        // 播放当前cell
        guard let cell = self.topCarouselView.cellForItem(at: indexPath) as? PlayListPlazaCarouselCell else {return}
        cell.frostedGlassView.alpha = 0
        
        let leftIndexPath = IndexPath(row: index-1, section: 0)
        guard let leftCell = self.topCarouselView.cellForItem(at: leftIndexPath) as? PlayListPlazaCarouselCell else{return}
        let rightIndexPath = IndexPath(row: index+1, section: 0)
        guard let rightCell = self.topCarouselView.cellForItem(at: rightIndexPath) as? PlayListPlazaCarouselCell else{return}
        leftCell.frostedGlassView.alpha = 0.5
        rightCell.frostedGlassView.alpha = 0.5
        
        let modelIndex = self.topCarouselViewInfinityIndexArr[indexPath.row]
        guard self.topCarouselModels.count > 0 else { return }
        let model = self.topCarouselModels[modelIndex]
        
        self.topCarouselViewScrollCenterCellObserver?.playListPlazaContentRecommendControllerTopCarouselViewScrollCenter(cell: cell, model:model, indexPath: indexPath)
        self.topCarouselCenterCellModel = model
    }
    
}
