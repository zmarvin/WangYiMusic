//
//  PlayListPlazaContentCommonController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PlayListPlazaContentCommonController: PlayListPlazaContentBaseController ,UICollectionViewDataSource ,UICollectionViewDelegate{
    
    var categoryModel : PlayListPlazaCategoryModel
    private let collectionView : UICollectionView
    private let reuseId = NSStringFromClass(PlayListPlazaContentCommonController.self)
    init(categoryModel:PlayListPlazaCategoryModel) {
        
        self.categoryModel = categoryModel
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50)/3
        let itemHeight = itemWidth + 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        self.collectionView.register(PlayListPlazaCommonCell.self, forCellWithReuseIdentifier: reuseId)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.dataModels == nil else {return}
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: { [unowned self] in
            API.get_playList(limit:18,cat:self.categoryModel.name).subscribe(onSuccess: {modes in
                self.dataModels = modes
                self.collectionView.reloadData()
                self.collectionView.mj_header?.endRefreshing()
            }).disposed(by: self.disposeBag)
        }).config().refresh()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PlayListPlazaCommonCell
        guard let model = self.dataModels?[indexPath.row] else { return cell }
        cell.titleLabel.text = model.name
        cell.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl)) { (image, error, cacheType, url) in
            guard indexPath.row == 0, let url = url else {return}
            Self.downloadedReadyRenderImageKeys.append(url)
            Self.downloadedReadyRenderImageKeysSubject.onNext(Self.downloadedReadyRenderImageKeys)
        }
        cell.playCountLabel.text = model.playCount
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section:\(indexPath.section),item:\(indexPath.item)")
        guard let model = self.dataModels?[indexPath.row] else { return }
        let vc = PlayListController(musicId: model.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

