//
//  PlayListPlazaContentBoutiqueController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/3.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift
class PlayListPlazaContentBoutiqueController: PlayListPlazaContentBaseController ,UICollectionViewDataSource ,UICollectionViewDelegate,UIViewControllerTransitioningDelegate{
    
    private let collectionView : UICollectionView
    private let cellReuseId = NSStringFromClass(PlayListPlazaContentBoutiqueController.self)
    private let headerReuseId = NSStringFromClass(PlayListPlazaContentBoutiqueControllerSectionHeader.self)

    init() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50)/3
        let itemHeight = itemWidth + 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView.register(PlayListPlazaCommonCell.self, forCellWithReuseIdentifier: cellReuseId)
        self.collectionView.register(PlayListPlazaContentBoutiqueControllerSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData(cat: nil)
    }
    
    @objc func requestData(cat: String?) {
        
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: { [unowned self] in
            API.get_boutiquePlayList(limit:18 ,cat: cat).subscribe(onSuccess: {modes in
                self.dataModels = modes
                self.collectionView.reloadData()
                self.collectionView.mj_header?.endRefreshing()
            }, onFailure: {err in
                self.collectionView.mj_header?.endRefreshing()
            }).disposed(by: disposeBag)
        }).config().refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! PlayListPlazaCommonCell
        guard let model = self.dataModels?[indexPath.row] else { return cell }
        cell.titleLabel.text = model.name
        cell.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl)){ (image, error, cacheType, url) in
            guard indexPath.row == 0, let url = url else {return}
            Self.downloadedReadyRenderImageKeys.append(url)
            Self.downloadedReadyRenderImageKeysSubject.onNext(Self.downloadedReadyRenderImageKeys)
        }
        cell.playCountLabel.text = model.playCount
        cell.markImageView.image = UIImage(named: "em_playlist_sup_hot_big")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath)
        
        if indexPath.section == 0 {
            let headerFilterBtn = UIButton()
            headerFilterBtn.setTitle("筛选", for: UIControl.State.normal)
            headerFilterBtn.setImage(UIImage(named: "em_playlist_btn_filter"), for: UIControl.State.normal)
            headerFilterBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            headerFilterBtn.titleLabel?.font = .systemFont(ofSize: 14)
            headerFilterBtn.addTarget(self, action: #selector(headerFilterBtnClick), for: UIControl.Event.touchUpInside)
            header.addSubview(headerFilterBtn)
            headerFilterBtn.snp.makeConstraints { (make) in
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.width.equalTo(50)
                make.right.equalToSuperview().offset(-15)
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section:\(indexPath.section),item:\(indexPath.item)")
        guard let model = self.dataModels?[indexPath.row] else { return }
        let vc = PlayListController(musicId: model.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UIViewControllerTransitioningDelegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PlayListPlazaAllBoutiqueCategoryPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    @objc func headerFilterBtnClick(){
        let vc = PlayListPlazaAllBoutiqueCategoryController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.didSelectedItemCallBack = { categoryModel in
            self.requestData(cat: categoryModel.name)
        }
        self.present(vc, animated: true, completion: nil)
    }
}

class PlayListPlazaContentBoutiqueControllerSectionHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        label.text = "全部"
        label.font = .systemFont(ofSize: 14)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.left.equalToSuperview().offset(15)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
