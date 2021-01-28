//
//  PlayListController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PlayListController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let disposeBag = DisposeBag()
    var API = PlayListRxAPI()
    var dataModels : [Music]?
    var musicId :Int
    let tableHeaderView = PlayListControllerHeaderView()
    let sectionHeaderView = PlayListControllerSectionHeaderView()
    let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
    var imageMostColor = UIColor.white
    
    init(musicId:Int) {
        self.musicId = musicId
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.nav_BackBarButtonColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "歌单"
        self.setUpView()
        self.setUpData()
    }
    
    func setUpView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PlayListCustomCell.self, forCellReuseIdentifier: "PlayListController")
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.sectionHeaderHeight = 50
        self.tableView.rowHeight = 60
        self.sectionHeaderView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 50)
        self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 280)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.tableHeaderView.imageView.rx.observe(\.image).subscribe(onNext:{ [unowned self] image in
            if let ima = image {
                self.imageMostColor = UIColor.mostColor(with: ima)
                self.tableView.backgroundColor = self.imageMostColor
                self.navigationController?.navigationBar.setBackgroundImage(self.imageMostColor.image(), for: UIBarMetrics.default)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func setUpData() {
        
        API.get_playList_detail(id: self.musicId).subscribe(onSuccess: {model in
            self.dataModels = model.musics
            self.tableView.reloadData()
            self.tableHeaderView.imageView.kf.setImageAspectFillScale(with: URL(string: model.coverImgUrl))
            self.tableHeaderView.titleLabel.text = model.name
            self.tableHeaderView.playCountLabel.text = model.playCount
            self.tableHeaderView.subscribedCountBtn.setTitle(model.subscribedCount, for: UIControl.State.normal)
            self.tableHeaderView.commentCountBtn.setTitle(model.commentCount, for: UIControl.State.normal)
            self.tableHeaderView.shareCountBtn.setTitle(model.shareCount, for: UIControl.State.normal)
            self.tableHeaderView.creatorAvatarImageView.kf.setImageAspectFillScale(with: URL(string: model.creator?.avatarUrl ?? ""))
            self.tableHeaderView.creatorNicknameLabel.text = model.creator?.nickname
            self.tableHeaderView.descriptionlabel.text = model.descriptions.replacingOccurrences(of: "\n", with: " ")
            if let m = model.musics {
                self.sectionHeaderView.numLabel.text = "(\(m.count))"
            }
        }, onFailure: {error in
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(self.imageMostColor.image(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        ]
        let right1 = UIBarButtonItem(image: UIImage(named: "em_playlist_detail_icn_search"), style: .plain, target: self, action: #selector(rightBarBtnClick))
        right1.tintColor = .white
        let right2 = UIBarButtonItem(image: UIImage(named: "em_playlist_moredot"), style: .plain, target: self, action: #selector(rightBarBtnClick))
        right2.tintColor = .white
        self.navigationItem.setRightBarButtonItems([right2,right1], animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }

    @objc func rightBarBtnClick(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "PlayListController", for: indexPath) as! PlayListCustomCell
        guard let models = self.dataModels else { return cell }
        let model = models[indexPath.row]
        cell.indexLabel.text = "\(indexPath.row+1)"
        cell.titleLabel.attributedText = model.attributedStringName
        cell.creatorLabel.text = model.creatorName
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let models = self.dataModels else { return }
        let model = models[indexPath.row]
//        if let id = model.id {
//            self.processor.pipeline(type: .some(PlayListDetailSignal.selectedMP3(id:id)))
//            EMRouter.push(EMRouter.oldmusicPlayController(.normal(id: model,list: models)))
//        }
        let vc = MusicPlayController()
        MusicPlayManager.shared.currentPlayingMusic = model
        MusicPlayManager.shared.currentPlayingMusics = models
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let delta = offsetY - self.tableHeaderView.beltBackgroundShadowView.frame.minY

//        if 0 <= delta && delta <= 20 {
//            let ratio = delta/20
//            self.tableHeaderView.beltBackgroundShadowView.alpha = 1 - ratio
//            self.tableHeaderView.beltBackgroundShadowView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
//        }else if 20 < delta {
//            self.tableHeaderView.beltBackgroundShadowView.alpha = 0
//            self.tableHeaderView.beltBackgroundShadowView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        }else {
//            self.tableHeaderView.beltBackgroundShadowView.alpha = 1
//            self.tableHeaderView.beltBackgroundShadowView.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
    }
    deinit {
        print("PlayListController销毁了")
    }
}
