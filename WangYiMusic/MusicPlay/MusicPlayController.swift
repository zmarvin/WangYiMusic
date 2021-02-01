//
//  MusicPlayController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/7.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

class MusicPlayController: UIViewController {

    let bottomControlViewHeight :CGFloat = 145
    let topBarViewH :CGFloat = WY_NAV_BAR_HEIGHT
    let MusciPlayCircularLayerRadiusToScreenW_ratio : CGFloat = 156/390.0
    
    let backgroundImageView = UIImageView()
    let backgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    let topBarView = MusicPlayTopBarView()
    let middleBackgroundView = UIView()
    let bottomControlView = MusicPlayBottomControlView()

    let circularTransparenceLayer = CAShapeLayer()
    let discCollectionView = MusicPlayDiscCollectionView()
    let needleImageView = UIImageView()
    let infoPannelView = MusicPlayInfoBarView()

    let API = MusicPlayRxAPI()
    let disposeBag = DisposeBag()

    var transitionManage = MusicPlayTransitionManage()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = transitionManage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpState()
    }

    func setUpView() {
        self.view.addSubview(self.backgroundImageView)

        self.backgroundImageView.addSubview(backgroundEffectView)
        self.backgroundImageView.addSubview(topBarView)
        self.backgroundImageView.addSubview(middleBackgroundView)
        self.backgroundImageView.addSubview(bottomControlView)
        middleBackgroundView.addSubview(discCollectionView)
        middleBackgroundView.addSubview(needleImageView)
        middleBackgroundView.addSubview(infoPannelView)

        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.isUserInteractionEnabled = true
        
        let topBarViewMaxY :CGFloat = topBarViewH + WY_STATUS_BAR_HEIGHT
        circularTransparenceLayer.lineWidth = 10;
        circularTransparenceLayer.strokeColor = UIColor(white: 1, alpha: 0.1).cgColor
        circularTransparenceLayer.fillColor = UIColor.clear.cgColor
        let circularLayerRadius : CGFloat = MusciPlayCircularLayerRadiusToScreenW_ratio * WY_SCREEN_WIDTH
        let circularLayerCenter = CGPoint(x: self.view.center.x, y: (self.view.frame.maxY - bottomControlViewHeight - topBarViewMaxY)/2)
        let path = UIBezierPath(arcCenter: circularLayerCenter, radius: circularLayerRadius, startAngle: 0, endAngle: 2*WY_M_PI, clockwise: true)
        circularTransparenceLayer.path = path.cgPath
        middleBackgroundView.layer.addSublayer(circularTransparenceLayer)

        needleImageView.image = UIImage(named: "em_play_needle_play")
        needleImageView.contentMode = .scaleAspectFit
        needleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/8))
        discCollectionView.backgroundColor = .clear
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        topBarView.snp.makeConstraints { (make) in
            make.top.equalTo(WY_STATUS_BAR_HEIGHT)
            make.left.right.equalToSuperview()
            make.height.equalTo(topBarViewH)
        }
        let bottomSafeMagrin :CGFloat = 20
        bottomControlView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomControlViewHeight - bottomSafeMagrin)
            make.bottom.equalToSuperview().offset(-bottomSafeMagrin)
        }
        
        middleBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(topBarView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomControlView.snp.top)
        }
        
        infoPannelView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }

        discCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.height.equalTo(discCollectionView.snp.width)
            make.centerY.equalToSuperview()
        }
        
        needleImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.middleBackgroundView.snp.top).offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(needleImageView.snp.width)
        }

        self.bottomControlView.loopBtn.addTarget(self, action: #selector(loopBtnClick), for: .touchUpInside)
        self.bottomControlView.lastBtn.addTarget(self, action: #selector(lastBtnClick), for: .touchUpInside)
        self.bottomControlView.controlBtn.addTarget(self, action: #selector(controlBtnClick), for: .touchUpInside)
        self.bottomControlView.nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        self.bottomControlView.menuBtn.addTarget(self, action: #selector(menuBtnClick), for: .touchUpInside)
        self.topBarView.backBtn.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        self.bottomControlView.progressBarView.sliderView.addTarget(self, action: #selector(sliderValue), for: .valueChanged)
        self.view.addGestureRecognizer(transitionManage.dismissalInteraction.interactiveGesture)
    }

    func setUpState() {
        
        if let playingMusics = MusicPlayManager.shared.currentPlayingMusics{
            discCollectionView.imageUrls = playingMusics.compactMap{$0.picUrl}
            discCollectionView.setCurrentIndex(index: MusicPlayManager.shared.currentPlayingIndex,animated: false)
            discCollectionView.scrollSelectItemCallBack = { index in
                let selectMusic = playingMusics[index]
                MusicPlayManager.shared.currentPlayingMusic = selectMusic
            }
            MusicPlayingTableView.shared.cellModels = playingMusics
            MusicPlayingTableView.shared.selectItemCallBack = { music in
                MusicPlayManager.shared.currentPlayingMusic = music
            }
        }
        
        MusicPlayManager.shared.rx.observe(\.currentPlayingMusic).distinctUntilChanged().subscribe(onNext: { [weak self] m in
            guard let music = m else {return}
            if let picUrl = music.picUrl,let url = URL(string:picUrl) {
                KingfisherManager.shared.retrieveImageCompletionHandlerOnMainQueue(with: url) { (image, error, cacheType, url) in
                    guard let imageView = self?.backgroundImageView else {return}
                    guard let unwrapImage = image else {return}
                    DispatchQueue(label: "MusicPlayConroller.backgroundImageView").async {
                        guard let scaleImage = unwrapImage.aspectFillScaleToSize(newSize: CGSize(width: 10, height: 10), scale: 1) else {return}
//                        guard let resultImage = scaleImage.gaussianBlur() else {return}
                        DispatchQueue.main.async {
                            let transitionAnimation = CABasicAnimation(keyPath: "contents")
                            transitionAnimation.fromValue = imageView.image
                            transitionAnimation.toValue = scaleImage
                            transitionAnimation.duration = 0.8
                            imageView.layer.add(transitionAnimation, forKey: "MusicPlayBackgroundImageTransitionAnimation")
                            imageView.image = scaleImage
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                            imageView.layer.removeAllAnimations()
                        }
                    }
                }
            }
            self?.navigationItem.title = music.name
            self?.topBarView.titleLabel.text = music.name
            self?.topBarView.creatorLabel.text = music.creatorName + ">"
            
            self?.bottomControlView.progressBarView.sliderView.setValue(0, animated: true)
            self?.bottomControlView.progressBarView.leftTimeLable.text = "00:00"
            self?.bottomControlView.progressBarView.rightTimeLable.text = "00:00"
            
            self?.discCollectionView.setCurrentIndex(index: MusicPlayManager.shared.currentPlayingIndex,animated: true)
        }).disposed(by: disposeBag)
        
        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            let player = MusicPlayManager.shared.audioPlayer
            let progress = player.progress
            let duration = player.duration
            self?.bottomControlView.progressBarView.sliderView.setValue(Float(progress/duration), animated: true)
            self?.bottomControlView.progressBarView.leftTimeLable.text = self?.formateTime(progress)
            self?.bottomControlView.progressBarView.rightTimeLable.text = self?.formateTime(duration)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(MusicPlayManager.shared.rx.observe(\.isPlaying), discCollectionView.rx.observe(\.isScrolling))
            .delaySubscription(RxTimeInterval.seconds(Int(musicPlayControllerTransitionAnimateDuration)), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isPlaying,isScrolling in
                if isPlaying && !isScrolling{
                    self?.discCollectionView.startAnimation()
                    self?.bottomControlView.controlBtn.isSelected = true
                    self?.setUpNeedleImageViewState(isDrop: true)
                }else if isPlaying && isScrolling{
                    self?.discCollectionView.pauseAnimation()
                    self?.bottomControlView.controlBtn.isSelected = true
                    self?.setUpNeedleImageViewState(isDrop: false)
                }else{// !isPlaying
                    self?.discCollectionView.pauseAnimation()
                    self?.bottomControlView.controlBtn.isSelected = false
                    self?.setUpNeedleImageViewState(isDrop: false)
                }
        }).disposed(by: disposeBag)
        
    }

    func setUpNeedleImageViewState(isDrop:Bool) {
        UIView.animate(withDuration: 0.2) {
            self.needleImageView.transform = CGAffineTransform(rotationAngle: isDrop ? 0 : CGFloat(-Double.pi/8) )
        }
    }
    
    @objc func loopBtnClick(btn:UIButton) {
        
        MusicPlayManager.shared.loopType.next()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        switch MusicPlayManager.shared.loopType {
        case .single:
            hud.label.text = "单曲播放"
        case .random:
            hud.label.text = "随机播放"
        case .cycle:
            hud.label.text = "循环播放"
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            hud.hide(animated: true)
        }
    }
    
    @objc func controlBtnClick() {
        if self.bottomControlView.controlBtn.isSelected {// 暂停
            MusicPlayManager.shared.stopMusic()
            
        }else{// 播放
            MusicPlayManager.shared.playMusic()
        }
    }
    
    @objc func nextBtnClick() {
        MusicPlayManager.shared.playNextMusic()
    }
    
    @objc func lastBtnClick() {
        MusicPlayManager.shared.playLastMusic()
    }

    @objc func menuBtnClick() {
        MusicPlayingTableView.shared.show()
    }
    
    @objc func sliderValue(slide:UISlider){
        let player = MusicPlayManager.shared.audioPlayer
        let ratio = slide.value
        let time = Double(ratio)*player.duration
        player.seek(toTime: time)
    }
    
    @objc func dismissController()  {
        self.transitionManage.dismissalInteraction.isInteraction = false
        self.dismiss(animated: true, completion: nil)
    }

    func formateTime(_ secounds:Double) -> String {
        if secounds.isNaN{
            return "00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        return String(format: "%02d:%02d", Min, Sec)
    }

    deinit {
        print("MusicPlayController 销毁了")
    }
}
