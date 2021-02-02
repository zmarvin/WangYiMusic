//
//  PlayListPlazaAllBoutiqueCategoryController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/4.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PlayListPlazaAllBoutiqueCategoryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let disposeBag = DisposeBag()
    var API = RxPlayListPlazaAPI()
    var dataModels : [PlayListPlazaCategoryModel]?
    var didSelectedItemCallBack : ((PlayListPlazaCategoryModel) -> Void)?
    let reuseId = NSStringFromClass(PlayListPlazaAllBoutiqueCategoryController.self)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (WY_SCREEN_WIDTH - 3*10 - 15*2)/4, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        cV.dataSource = self
        cV.delegate = self
        cV.register(PlayListAllCategoryCell.self, forCellWithReuseIdentifier: reuseId)
        cV.backgroundColor = .white
        return cV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "所有精品歌单"
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = true
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let subTitleLabel = UILabel()
        let subTitleLabelW : CGFloat = 40
        subTitleLabel.text = "全部精品"
        subTitleLabel.font = .systemFont(ofSize: 13)
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = .white
        subTitleLabel.backgroundColor = .red
        subTitleLabel.layer.cornerRadius = subTitleLabelW/2
        subTitleLabel.layer.masksToBounds = true
        self.view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(subTitleLabelW)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        let delBtn = UIButton()
        delBtn.setImage(UIImage(named: "em_playlist_icn_dlt"), for: UIControl.State.normal)
        titleLabel.addSubview(delBtn)
        delBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(delBtn.snp.height)
        }
        
        delBtn.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        API.get_playListAllBoutiqueCategory().subscribe(onSuccess: {models in
            self.dataModels = models
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PlayListAllCategoryCell
        guard let model = self.dataModels?[indexPath.row] else { return cell }
        cell.titleBtn.setTitle(model.name, for: UIControl.State.normal)
        cell.titleBtn.titleLabel?.font = .systemFont(ofSize: 15)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.dataModels?[indexPath.row] else { return }
        if let callBack = didSelectedItemCallBack {
            callBack(model)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

