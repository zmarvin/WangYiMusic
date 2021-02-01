//
//  MusicPlayControllPannelView.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/12.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class MusicPlayShrinkControllPannelView: UIButton, UINavigationControllerDelegate, CAAnimationDelegate {
    
    @objc static let shared = MusicPlayShrinkControllPannelView()
    let disposeBag = DisposeBag()
    private var selfHeightNotIncludeSafeBottom : CGFloat = WY_TAB_BAR_HEIGHT
    private lazy var picViewinsetsMargin :CGFloat = selfHeightNotIncludeSafeBottom * (1 - MusicPlayPicToDisc_Ratio) / 2
    private let topDivideLine = UIView()
    let discImageView = UIImageView()
    let picView = UIImageView()
    let musicNameLabel = UILabel()
    let playOrPauseBtn = MusicPlayShrinkControlPannelProgressBtn()
    let listBtn = UIButton()
    let discAnimationKey = NSStringFromClass(MusicPlayShrinkControllPannelView.self)
    var animationDidStart : (()->Void)?
    var isShow = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
        self.setUpInfo()
    }
    
    func setUpView() {
        
        self.addSubview(musicNameLabel)
        self.addSubview(playOrPauseBtn)
        self.addSubview(listBtn)
        self.addSubview(topDivideLine)
        self.addSubview(discImageView)
        discImageView.addSubview(picView)
        self.backgroundColor = .white
        topDivideLine.backgroundColor = .lightGray
        
        discImageView.image = UIImage(named: "em_play_disc_cover")
        discImageView.contentMode = .scaleAspectFit
        
        picView.layer.cornerRadius = selfHeightNotIncludeSafeBottom * MusicPlayPicToDisc_Ratio / 2
        picView.layer.masksToBounds = true
        playOrPauseBtn.setImage(UIImage(named: "em_play_pannel_play"), for: UIControl.State.normal)
        playOrPauseBtn.setImage(UIImage(named: "em_play_pannel_pause"), for: UIControl.State.selected)
        listBtn.setImage(UIImage(named: "em_vehicle_btn_src_prs"), for: UIControl.State.normal)
        
        playOrPauseBtn.addTarget(self, action: #selector(playOrPauseBtnClick), for: UIControl.Event.touchUpInside)
        self.addTarget(self, action: #selector(showPlayMusicController), for: UIControl.Event.touchUpInside)

        topDivideLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.18)
        }
        
        discImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(-4)
            make.width.height.equalTo(selfHeightNotIncludeSafeBottom)
        }
        
        picView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: picViewinsetsMargin, left: picViewinsetsMargin, bottom: picViewinsetsMargin, right: picViewinsetsMargin))
        }
        
        listBtn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview()
            make.height.equalTo(selfHeightNotIncludeSafeBottom)
        }
        
        playOrPauseBtn.snp.makeConstraints { (make) in
            make.right.equalTo(listBtn.snp.left)
            make.width.equalTo(listBtn)
            make.top.equalToSuperview()
            make.height.equalTo(selfHeightNotIncludeSafeBottom)
        }

        musicNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(discImageView.snp.right).offset(10)
            make.right.equalTo(playOrPauseBtn.snp.left)
            make.top.equalToSuperview()
            make.height.equalTo(selfHeightNotIncludeSafeBottom)
        }
    }
    
    func setUpInfo() {
        
        MusicPlayManager.shared.rx.observe(\.currentPlayingMusic).subscribe(onNext: { music in
            
            guard let prefix = music?.name else { return }
            guard var suffix = music?.creatorName else { return }
            suffix = " - " + suffix
            let string = prefix + suffix
            let leftAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]
            let rightAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)
            ]
            let attString = NSMutableAttributedString(string: string)
            attString.addAttributes(leftAttribute, range:NSRange(location: 0, length: prefix.count))
            attString.addAttributes(rightAttribute, range: NSRange(location: prefix.count, length: suffix.count))
            
            self.musicNameLabel.attributedText = attString
            if let picU = music?.picUrl{
                self.picView.kf.setImage(with: URL(string: picU), placeholder: UIImage(named: "em_play_default_cover"))
            }
        }).disposed(by: disposeBag)
        
        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {_ in
            let player = MusicPlayManager.shared.audioPlayer
            let progress = player.progress
            let duration = player.duration
            self.playOrPauseBtn.progress = CGFloat(progress/duration)
        }).disposed(by: disposeBag)
        
        MusicPlayManager.shared.rx.observe(\.isPlaying).observe(on: MainScheduler.instance).subscribe(onNext: { isPlaying in
            self.playOrPauseBtn.isSelected = isPlaying
            if isPlaying {
                self.resumeAnimation()
            }else{
                self.pauseAnimation()
            }
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popGestureCancelled), name: NSNotification.Name.WYScreenEdgePopGestureCancelled, object: nil)
    }
    
    func reSetUpAnimation(fromValue:CGFloat, animationDidStart: ( ()->Void )? ) {
        self.animationDidStart = animationDidStart
        self.discImageView.layer.removeAllAnimations()
        self.setUpAnimation(fromValue: fromValue)
        if MusicPlayManager.shared.isPlaying {
            self.resumeAnimation()
        }else{
            self.pauseAnimation()
            // 防止暂停状态animationDidStart没有调用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                self.animationDidStart?()
                self.animationDidStart = nil
            }
        }
    }
    
    func setUpAnimation(fromValue:CGFloat) {
        if let _ = self.discImageView.layer.animation(forKey: discAnimationKey) {return}
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = fromValue
        rotationAnim.toValue = fromValue + WY_M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 8
        rotationAnim.fillMode = CAMediaTimingFillMode.forwards
        rotationAnim.beginTime = 0
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.autoreverses = false
        rotationAnim.delegate = self
        self.discImageView.layer.add(rotationAnim, forKey: discAnimationKey)
    }
    
    func pauseAnimation() {
        if self.discImageView.layer.speed == 0 {
            return
        }
        let pauseTime = self.discImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.discImageView.layer.timeOffset = pauseTime
        self.discImageView.layer.speed = 0.0
    }

    func resumeAnimation() {
        guard let _ = self.discImageView.layer.animation(forKey: discAnimationKey) else {
            self.setUpAnimation(fromValue: 0)
            self.resumeAnimation()
            return
        }
        if self.discImageView.layer.speed == 1 {
            return
        }
        let pauseTime = self.discImageView.layer.timeOffset
        self.discImageView.layer.speed = 1.0
        self.discImageView.layer.timeOffset = 0.0
        self.discImageView.layer.beginTime = 0.0
        let timeSincePause = self.discImageView.layer.convertTime(CACurrentMediaTime() - pauseTime, from: nil)
        self.discImageView.layer.beginTime = timeSincePause
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.animationDidStart?()
        self.animationDidStart = nil
    }

    @objc func playOrPauseBtnClick() {
        if self.playOrPauseBtn.isSelected {// 暂停
            MusicPlayManager.shared.stopMusic()
        }else{// 播放
            MusicPlayManager.shared.playMusic()
        }
    }
    
    @objc func showPlayMusicController() {
        let vc = MusicPlayController()
        self.navController()?.topViewController?.present(vc, animated: true, completion: nil)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.refrashFrame()
        }, completion: { isCom in
            self.adjustControllerViewFrameHeight(with: viewController, with: navigationController)
        })
    }
    
    @objc func popGestureCancelled(noti:Notification){
        UIView.animate(withDuration: 0.3) {
            self.refrashFrame()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    func adjustControllerViewFrameHeight(with viewController:UIViewController,with navigationController: UINavigationController) {
        guard let nav = navigationController as? EMBaseNavigationController else { return }
        if !nav.isHideTabBar && self.isShow && !nav.isNavigationBarHidden{
            // 当TAB_BAR和shrinkConrollPannel同时显示时，修改viewcontroller.view.frame.height - selfHeightNotIncludeSafeBottom
            let topHeight = WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
            let bottomHeight = WY_TAB_BAR_HEIGHT + WY_SAFE_BOTTOM_MARGIN + self.selfHeightNotIncludeSafeBottom
            let height = WY_SCREEN_HEIGHT - topHeight - bottomHeight
            viewController.viewDidLayoutSubviews_Inject{
                viewController.view.frame.size.height = height
            }
        }
    }
    
    func navController() -> UINavigationController? {
        if let navC = UIApplication.shared.keyWindow?.rootViewController?.children.first as? UINavigationController{
            return navC
        }
        return nil
    }
    
    let tabBar : UITabBar? = {
        if let tabbarVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController{
            return tabbarVC.tabBar
        }
        return nil
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refrashFrame() {
        guard let nav = self.navController() as? EMBaseNavigationController else { return }
        let isHideTabBar = nav.isHideTabBar
        var selfHeight : CGFloat = selfHeightNotIncludeSafeBottom
        if WY_IS_IPHONEX && isHideTabBar{
            selfHeight = selfHeightNotIncludeSafeBottom + WY_SAFE_BOTTOM_MARGIN
        }
        if isHideTabBar {
            self.frame = CGRect(x: 0, y: WY_SCREEN_HEIGHT - selfHeight, width: WY_SCREEN_WIDTH, height: selfHeight)
        }else{
            let y = WY_SCREEN_HEIGHT - selfHeight - WY_TAB_BAR_HEIGHT - WY_SAFE_BOTTOM_MARGIN
            self.frame = CGRect(x: 0, y: y, width: WY_SCREEN_WIDTH, height: selfHeight)
        }
    }
    static func show() {
        MusicPlayShrinkControllPannelView.show(belowSubview: nil)
    }
    static func show(belowSubview:UIView?) {
        let shareInstence = MusicPlayShrinkControllPannelView.shared
        if let nav = shareInstence.navController(){
            nav.delegate = shareInstence
        }
        if let keyW = UIApplication.shared.keyWindow {
            if let belowView = belowSubview{
                keyW.insertSubview(shareInstence, belowSubview: belowView)
            }else{
                keyW.addSubview(shareInstence)
            }
        }
        shareInstence.refrashFrame()
        shareInstence.isShow = true
    }
    
    static func hide() {
        let shareInstence = MusicPlayShrinkControllPannelView.shared
        shareInstence.removeFromSuperview()
        shareInstence.isShow = false
    }
}

