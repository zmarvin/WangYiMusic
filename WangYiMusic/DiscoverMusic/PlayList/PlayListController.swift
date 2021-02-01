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
    var headerBackgroundImage : UIImage?
    var headerUpPartNavBackgroundImage : UIImage?
    let reuseId = "PlayListController"
    let backStretchImageView = UIImageView()
    let titleLabel = UILabel()
    
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

        self.setUpView()
        self.setupState()
        self.setUpData()
    }
    func setUpView() {
        
        titleLabel.text = "歌单"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: 140, height: WY_NAV_BAR_HEIGHT))
        let titleView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 140, height: WY_NAV_BAR_HEIGHT)))
        titleView.clipsToBounds = true
        titleView.addSubview(titleLabel)
        self.navigationItem.titleView = titleView
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PlayListCustomCell.self, forCellReuseIdentifier: reuseId)
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderHeight = 50
        self.tableView.rowHeight = 60
        self.sectionHeaderView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 50)
        let tableHeaderViewH : CGFloat = 280
//        self.tableView.contentInset = UIEdgeInsets(top: tableHeaderViewH, left: 0, bottom: 0, right: 0)
        self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: tableHeaderViewH)
        self.view.addSubview(self.tableView)
//        tableView.addSubview(tableHeaderView)
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.tableView.insertSubview(backStretchImageView, at: 0)
        backStretchImageView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 1)
    }
    
    func setupState() {
        self.tableHeaderView.imageView.rx.observe(\.image).subscribe(onNext:{ [unowned self] image in
            if let image = image {
//                let imageMostColor = UIColor.mostColor(with: image)
//                self.tableView.backgroundColor = imageMostColor
                
                let upExpectHeight = WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
                let downExpectHeight = self.tableHeaderView.imageViewHeight
                let expectHeight = upExpectHeight + downExpectHeight
                let expectWidth = WY_SCREEN_WIDTH
                // 缩小尺寸
                let shrinkWidth : CGFloat = 3
                let shrinkHeight = shrinkWidth * expectHeight/expectWidth
                let shrinkImage = image.reSize(newSize: CGSize(width: shrinkWidth, height: shrinkHeight), scale: 1)
                let upShrinkHeight = upExpectHeight/expectHeight * shrinkHeight
                let downShrinkHeight = shrinkHeight - upShrinkHeight
                let upShrinkImage = shrinkImage?.cut(rect: CGRect(x: 0, y: 0, width: shrinkWidth, height: upShrinkHeight))
                let downShrinkImage = shrinkImage?.cut(rect: CGRect(x: 0, y: upShrinkHeight, width: shrinkWidth, height: downShrinkHeight))
                // 放大到期望的尺寸
                let upExpectImageT = upShrinkImage?.reSize(newSize: CGSize(width: expectWidth, height: upExpectHeight), scale: 1)
                let downExpectImageT = downShrinkImage?.reSize(newSize: CGSize(width: expectWidth, height: downExpectHeight), scale: 1)
                let blurNumber : CGFloat = 99
                let upExpectImage = UIImage.boxBlurImage( upExpectImageT, withBlurNumber: blurNumber).resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: UIImage.ResizingMode.stretch)
                let downExpectImage = UIImage.boxBlurImage( downExpectImageT, withBlurNumber: blurNumber)
                
                self.navigationController?.navigationBar.setBackgroundImage(upExpectImage, for: UIBarMetrics.default)
                self.tableHeaderView.backgroundImageView.image = downExpectImage
                
                self.headerUpPartNavBackgroundImage = upExpectImage
                UIGraphicsBeginImageContext(CGSize(width: expectWidth, height: expectHeight))
                upExpectImage.draw(in: CGRect(origin: .zero, size: CGSize(width: expectWidth, height: upExpectHeight)))
                downExpectImage.draw(in: CGRect(x: 0, y: upExpectHeight, width: expectWidth, height: downExpectHeight))
                let jointImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.headerBackgroundImage = jointImage
                self.backStretchImageView.image = downExpectImage.cut(rect: CGRect(x: 0, y: 0, width: expectWidth, height: 1))
            }
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.WYScreenEdgePopGestureCancelled).subscribe(onNext: {[unowned self] _ in
            self.navigationController?.navigationBar.setBackgroundImage(self.headerUpPartNavBackgroundImage, for: UIBarMetrics.default)
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
//        self.navigationController?.navigationBar.setBackgroundImage(self.imageMostColor.image(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
//        ]
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
        let cell  = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! PlayListCustomCell
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

        let vc = MusicPlayController()
        MusicPlayManager.shared.currentPlayingMusic = model
        MusicPlayManager.shared.currentPlayingMusics = models
        self.present(vc, animated: true, completion: nil)
    }
    
    lazy var beltMinOffsetY = self.tableHeaderView.beltBackgroundView.frame.origin.y
    lazy var beltMaxOffsetY = self.tableHeaderView.beltBackgroundView.frame.midY
    lazy var beltHeight = self.tableHeaderView.beltBackgroundView.bounds.height
    lazy var beltWidth = self.tableHeaderView.beltBackgroundView.bounds.width
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        if offsetY < beltMinOffsetY {
            self.tableHeaderView.beltBackgroundView.alpha = 1
            self.tableHeaderView.beltBackgroundView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }else if beltMinOffsetY <= offsetY && offsetY <= beltMaxOffsetY {
            let deltaH = offsetY - beltMinOffsetY
//            let deltaW = deltaH/beltHeight * beltWidth
            let transformHeight = beltHeight - deltaH * 2
            let ratio = transformHeight/beltHeight
//            let transformWidth = ratio * width
            let transformAplha = ratio - 0.6 >= 0 ? ratio - 0.6 : 0
            self.tableHeaderView.beltBackgroundView.alpha = transformAplha
            self.tableHeaderView.beltBackgroundView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        }else{// offsetY > beltMaxOffsetY
            self.tableHeaderView.beltBackgroundView.alpha = 0
            self.tableHeaderView.beltBackgroundView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        if offsetY > 0 { // 上拉
            guard let headerBackgroundImage = self.headerBackgroundImage else { return }
            guard offsetY < headerBackgroundImage.size.height else {return}
            let cutH : CGFloat = WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
            let cutY : CGFloat = offsetY
            let cutX : CGFloat = 0
            let cutW : CGFloat = WY_SCREEN_WIDTH
            let navBackgroundImage = headerBackgroundImage.cut(rect: CGRect(x: cutX, y: cutY, width: cutW, height: cutH))?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: UIImage.ResizingMode.stretch)
            self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage, for: UIBarMetrics.default)
            self.headerUpPartNavBackgroundImage = navBackgroundImage
        }else{ // 下拉
            let increment = abs(offsetY)
            
//            let scaleHeight = headerImageViewFrame.height + increment
//            let scale = scaleHeight/headerImageViewFrame.height
//            let scaleWidth = headerImageViewFrame.width*scale
//
//            let x = -(scaleWidth - headerImageViewFrame.width) * 0.5
//            let y = -(scaleHeight - headerImageViewFrame.height)
//            self.tableHeaderView.backgroundImageView.frame = CGRect(x: x, y: y, width: scaleWidth, height: scaleHeight)
//            print("frame:",self.tableHeaderView.backgroundImageView.frame)
            
            backStretchImageView.frame = CGRect(x: 0, y: -increment, width: WY_SCREEN_WIDTH, height: increment)
        }
        
        if offsetY > 100 {
            titleLabel.text = self.tableHeaderView.titleLabel.text
            guard let text = titleLabel.text else { return }
            let titleWidth = text.boundingRect(with: CGSize(width: WY_SCREEN_WIDTH, height: 200), font: titleLabel.font).width
            let minus = titleWidth - titleLabel.bounds.width
            guard minus > 0 else {return}
            titleLabel.frame.size.width = titleWidth
            
            let moveAnim = CABasicAnimation(keyPath: "position.x")
            moveAnim.fromValue = titleLabel.center.x
            moveAnim.toValue = titleLabel.center.x - minus
            moveAnim.repeatCount = MAXFLOAT
            moveAnim.duration = 5
            moveAnim.fillMode = CAMediaTimingFillMode.forwards
            moveAnim.beginTime = CACurrentMediaTime() + 1
            moveAnim.isRemovedOnCompletion = false
            titleLabel.layer.add(moveAnim, forKey: "moveAnim")
        }else{
            titleLabel.text = "歌单"
            titleLabel.frame.size.width = self.navigationItem.titleView!.bounds.size.width
            titleLabel.layer.removeAllAnimations()
        }
        
    }
    lazy var headerImageViewFrame = self.tableHeaderView.backgroundImageView.frame
    deinit {
        print("PlayListController销毁了")
    }
}
