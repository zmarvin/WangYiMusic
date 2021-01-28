//
//  PlayListAllCategoryController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

let playListAllCategorySectionHeaderLabelFontSize : CGFloat = 14
let playListAllCategorySectionHeaderHeight : CGFloat = 50

class PlayListPlazaOverallCategoryController: UICollectionViewController {
    let disposeBag = DisposeBag()
    var API = RxPlayListPlazaAPI()
    var inPlazaCategoryModels: [PlayListPlazaCategoryModel]?{
        didSet{
            let prefix = "我的歌单广场"
            let suffix = "(长按可编辑)"
            let string = prefix + suffix
            let leftAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: playListAllCategorySectionHeaderLabelFontSize)
            ]
            let rightAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
            let attString = NSMutableAttributedString(string: string)
            attString.addAttributes(leftAttribute, range:NSRange(location: 0, length: prefix.count))
            attString.addAttributes(rightAttribute, range: NSRange(location: prefix.count, length: suffix.count))
            var sectionModel =  PlayListPlazaCategorySectionModel()
            sectionModel.title = ""
            sectionModel.attributedTitle = attString
            if let models = inPlazaCategoryModels {
                sectionModel.data = models
            }
            self.inPlazaCategorySectionModel = sectionModel
        }
    }
    var inPlazaCategorySectionModel = PlayListPlazaCategorySectionModel()
    
    var dataModels : [PlayListPlazaCategorySectionModel]?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        self.navigationItem.title = "所有歌单"
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: WY_SCREEN_WIDTH, height: playListAllCategorySectionHeaderHeight)
        let insetMargin : CGFloat = 15
        layout.itemSize = CGSize(width: (WY_SCREEN_WIDTH - 3*10 - insetMargin*2)/4, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetMargin, bottom: 0, right: insetMargin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.collectionView.register(PlayListAllCategoryCell.self, forCellWithReuseIdentifier: "PlayListPlazaOverallCategoryController")
        self.collectionView.register(PlayListAllCategorySectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlayListPlazaOverallCategoryControllerSectionHeader")
        API.get_playListAllCategory().subscribe(onSuccess: {modes in
            self.dataModels = modes
            self.dataModels?.insert(self.inPlazaCategorySectionModel, at: 0)
            self.collectionView.reloadData()
        }, onFailure: {err in
            
        }).disposed(by: disposeBag)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataModels?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = self.dataModels?[section]
        return sectionModel?.data.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListPlazaOverallCategoryController", for: indexPath) as! PlayListAllCategoryCell
        let sectionModel = self.dataModels?[indexPath.section]
        guard let model = sectionModel?.data[indexPath.row] else { return cell }
        cell.titleBtn.setTitle(model.name, for: UIControl.State.normal)
        if model.hot {
            cell.titleBtn.setImage(UIImage(named: "em_playlist_hall_hot_icon"), for: UIControl.State.normal)
        }else{
            cell.titleBtn.setImage(nil, for: UIControl.State.normal)
        }
        guard let inPlazaCategoryModels = self.inPlazaCategoryModels else { return cell }
        if indexPath.section != 0 && inPlazaCategoryModels.map({$0.name}).contains(model.name) {
            cell.titleBtn.alpha = 0.5
            cell.titleBtn.backgroundColor = UIColor.white
        }else{
            cell.titleBtn.alpha = 1
            cell.titleBtn.backgroundColor = UIColor(red: 251/255.0, green: 249/255.0, blue: 251/255.0, alpha: 1)
        }
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlayListPlazaOverallCategoryControllerSectionHeader", for: indexPath) as! PlayListAllCategorySectionHeader
        guard let sectionModel = self.dataModels?[indexPath.section] else {return headerCell}
        if sectionModel.title.count > 0 {
            headerCell.titleLabel.text = sectionModel.title
        }else{
            headerCell.titleLabel.attributedText = sectionModel.attributedTitle
        }
        
        if indexPath.section == 0 {
            let sectionHeaderEditBtn = UIButton()
            sectionHeaderEditBtn.setTitle("编辑", for: UIControl.State.normal)
            sectionHeaderEditBtn.setTitleColor(UIColor(red: 250/255, green: 100/255, blue: 100/255, alpha: 1), for: UIControl.State.normal)
            sectionHeaderEditBtn.layer.borderWidth = 0.5
            sectionHeaderEditBtn.layer.borderColor = UIColor.red.cgColor
            sectionHeaderEditBtn.titleLabel?.font = .systemFont(ofSize: 13)
            headerCell.addSubview(sectionHeaderEditBtn)
            sectionHeaderEditBtn.snp.makeConstraints { (make) in
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.width.equalTo(60)
                make.right.equalToSuperview().offset(-15)
            }
            sectionHeaderEditBtn.layer.cornerRadius = 12.5
            sectionHeaderEditBtn.layer.masksToBounds = true
        }else{
            headerCell.subviews.filter{$0 is UIButton}.first?.removeFromSuperview()
        }
        return headerCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section:\(indexPath.section),item:\(indexPath.item)")
        let sectionModel = self.dataModels?[indexPath.section]
        guard let model = sectionModel?.data[indexPath.row] else { return }
        let vc = PlayListPlazaContentCommonController(categoryModel:model)
        vc.navigationItem.title = model.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class PlayListAllCategorySectionHeader: UICollectionReusableView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: playListAllCategorySectionHeaderLabelFontSize)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
