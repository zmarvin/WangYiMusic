//
//  SearchViewController.swift
//  testSwift
//
//  Created by mac on 2020/12/27.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class SearchViewController: UISearchController, UICollectionViewDataSource, UICollectionViewDelegate{
    let disposeBag = DisposeBag()
    let API = SearchRxAPI()
    
    private let backgroundScrollView = UITableView()
    private let collectionView : UICollectionView
    private let collectionViewCellIdentifier = "SearchViewControllerCollectionView"
    private let itemHeight : CGFloat  = 35
    private let headerHeight : CGFloat  = 50
    private var unfoldMoreView = UnfoldMoreView()
    private var searchModels = [HotSearchModel]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(searchResultsController: UIViewController?) {
        // setup collectionView
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(searchResultsController: searchResultsController)
        
        self.backgroundScrollView.tableFooterView = UIView()
        self.view.addSubview(backgroundScrollView)
        backgroundScrollView.frame = self.view.bounds
        
        let recruitImageView = UIImageView(image: UIImage(named: "search_recruit"))
        recruitImageView.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width-30, height: 65)
        recruitImageView.contentMode = .scaleAspectFit
        self.backgroundScrollView.addSubview(recruitImageView)
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: headerHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.frame = CGRect(x: 0, y: recruitImageView.frame.maxY, width: UIScreen.main.bounds.width, height: itemHeight*5+headerHeight)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchCollectionViewHeader")
        collectionView.backgroundColor = .white

        self.backgroundScrollView.addSubview(self.collectionView)
        
        
        unfoldMoreView = UnfoldMoreView(frame: CGRect(x: 0, y: collectionView.frame.maxY, width: UIScreen.main.bounds.width, height: 40))
        unfoldMoreView.addTarget(self, action: #selector(unfoldMoreHotSearch), for: UIControl.Event.touchUpInside)
        self.backgroundScrollView.addSubview(self.unfoldMoreView)
        
        if let resultView = searchResultsController?.view {
            self.view.addSubview(resultView)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.definesPresentationContext = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moreHotSearchIsUnfold(isUnfold: false)
        // 请求数据
        API.get_hotSearch().subscribe { (models) in
            self.searchModels = models
            self.collectionView.reloadData()
        } onFailure: { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as!SearchCollectionViewCell
        let model = self.searchModels[indexPath.row]
        
        cell.indexLabel.text = "\(indexPath.row)"
        cell.title = model.searchWord
        cell.iconImageView.kf.setImage(with: URL(string: model.iconUrl))
        
        func removeIndexImageView(){
            if cell.indexLabel.subviews.count > 0 {
                for view in cell.indexLabel.subviews {
                    view.removeFromSuperview()
                }
            }
        }
        if indexPath.row == 0 {
            let indexImageView = UIImageView(image: UIImage(named: "search_hot_num1"))
            indexImageView.contentMode = .scaleAspectFit
            indexImageView.tintColor = .red
            cell.indexLabel.addSubview(indexImageView)
            indexImageView.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview().offset(7)
                make.right.bottom.equalToSuperview().offset(-7)
            }
            cell.indexLabel.text = ""
        }else if indexPath.row < 4 {
            cell.indexLabel.textColor = .red
            removeIndexImageView()
        }else{
            cell.indexLabel.textColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
            removeIndexImageView()
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionViewHeader", for: indexPath)
        
        let label = UILabel()
        let playBtn = UIButton()
        
        playBtn.setTitle("▶播放", for: UIControl.State.normal)
        playBtn.setTitleColor(.gray, for: UIControl.State.normal)
        playBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        let offsetY :CGFloat = 13
        playBtn.frame = CGRect(x: header.frame.width - 75, y: offsetY, width: 60, height: header.frame.height-2*offsetY)
        playBtn.layer.cornerRadius = playBtn.frame.height/2
        playBtn.layer.borderWidth = 0.2
        playBtn.layer.borderColor = UIColor.gray.cgColor
        _ = playBtn.rx.tap.subscribe(onNext: {
            print("热搜榜播放")
        })
        
        label.text = "热搜榜"
        label.font = .systemFont(ofSize: 16)
        label.frame = CGRect(x: 18, y: 0, width: header.frame.width*0.5, height: header.frame.height)
        
        header.addSubview(label)
        header.addSubview(playBtn)
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index:\(indexPath.row)")
        let model = self.searchModels[indexPath.row]
        self.searchBar.text = model.searchWord
    }
    
    @objc func unfoldMoreHotSearch(btn: UIButton ){
        
        moreHotSearchIsUnfold(isUnfold: true)
    }
    
    func moreHotSearchIsUnfold(isUnfold:Bool) {
        if isUnfold {
            unfoldMoreView.removeFromSuperview()
            let offset = itemHeight*5
            collectionView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: itemHeight*5+headerHeight+offset)
        }else{
            unfoldMoreView.frame = CGRect(x: 0, y: 70+itemHeight*5+headerHeight, width: UIScreen.main.bounds.width, height: 40)
            if let view = self.searchResultsController?.view {
                self.backgroundScrollView.insertSubview(unfoldMoreView, belowSubview: view)
            }
            
            collectionView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: itemHeight*5+headerHeight)
        }
    }
}

class UnfoldMoreView: UIButton {
    let textLabel = UILabel()
    let coustomeImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textLabel)
        self.addSubview(coustomeImageView)
        
        let image = UIImage(named: "cm4_icn_tip_down_arrow")
        coustomeImageView.image = image
        
        let imageSize = image?.size ?? CGSize.zero
        
        let text = "展开更多热搜"
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 13)
        let attrs = [NSAttributedString.Key.font : textLabel.font]
        let textSize = text.boundingRect(with: CGSize(width: 200, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
        let contentW = textSize.width + imageSize.width
        
        textLabel.frame = CGRect(x: (frame.width-contentW)/2, y: 0, width: textSize.width, height: frame.height)
        let offsetH : CGFloat = 20
        coustomeImageView.frame = CGRect(x: (frame.width-contentW)/2 + textSize.width , y: offsetH/2, width:imageSize.width+10, height: frame.height - offsetH)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


