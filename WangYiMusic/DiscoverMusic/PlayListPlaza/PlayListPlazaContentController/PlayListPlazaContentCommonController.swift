//
//  PlayListPlazaContentCommonController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PlayListPlazaContentCommonController: UICollectionViewController {
    
    private let disposeBag = DisposeBag()
    private var API = RxPlayListPlazaAPI()
    private var dataModels : [PlayListPlazaModel]?
    private var categoryModel : PlayListPlazaCategoryModel
    init(categoryModel:PlayListPlazaCategoryModel) {
        let layout = UICollectionViewFlowLayout()
        self.categoryModel = categoryModel
        super.init(collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50)/3
        let itemHeight = itemWidth + 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        self.collectionView.register(PlayListPlazaCommonCell.self, forCellWithReuseIdentifier: "PlayListPlazaContentCommonController")
        self.collectionView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let header = MJRefreshGifHeader(refreshingBlock: { [unowned self] in
            API.get_playList(limit:18,cat:self.categoryModel.name).subscribe(onSuccess: {modes in
                self.dataModels = modes
                self.collectionView.reloadData()
                self.collectionView.mj_header?.endRefreshing()
            }).disposed(by: self.disposeBag)
        })
        header.setTitle("加载中...", for: MJRefreshState.idle)
        header.setTitle("加载中...", for: MJRefreshState.pulling)
        header.setTitle("加载中...", for: MJRefreshState.refreshing)
        header.setImages(WY_LIST_LOADING_IMAGES, for: MJRefreshState.refreshing)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.collectionView.mj_header = header
        header.beginRefreshing()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModels?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListPlazaContentCommonController", for: indexPath) as! PlayListPlazaCommonCell
        guard let model = self.dataModels?[indexPath.row] else { return cell }
        cell.titleLabel.text = model.name
        cell.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl))
        cell.playCountLabel.text = model.playCount
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section:\(indexPath.section),item:\(indexPath.item)")
        guard let model = self.dataModels?[indexPath.row] else { return }
        let vc = PlayListController(musicId: model.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

