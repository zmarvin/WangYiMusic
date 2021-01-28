//
//  MusicPlayDiscCollectionViewCell.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/25.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift

let MusicPlayPicToDisc_Ratio : CGFloat = 0.6 // 宽度比例picView.width/screenWidth
class MusicPlayDiscCollectionViewCell: UICollectionViewCell, CAAnimationDelegate {
    let disposeBag = DisposeBag()
    
    let discImageView = UIImageView()
    let picView = UIImageView()
    let discAnimationKey = NSStringFromClass(MusicPlayDiscCollectionViewCell.self)

    var animationDidStart : (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(discImageView)
        discImageView.addSubview(picView)
        
        picView.rx.observe(\.bounds).element(at: 1).subscribe(onNext: { [weak self] frame in
            guard frame.width > 0 else {return}
            let radius = frame.width/2
            self?.picView.cornersRound(radius: radius)
        }).disposed(by: disposeBag)
        
        // MARK: view动画使用
//        picView.layer.cornerRadius = 97.5
//        picView.layer.masksToBounds = true
        
        discImageView.image = UIImage(named: "em_play_disc_cover")
        discImageView.contentMode = .scaleAspectFit

        discImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let margin = (1 - MusicPlayPicToDisc_Ratio) * frame.width/2
        picView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.discImageView.layer.removeAllAnimations()
    }
    //  MARK: animationDidStart layer动画的启动是异步的，解决衔接时，偶有抖闪的问题
    func reSetUpAnimation(fromValue:CGFloat,animationDidStart: ( ()->Void )? ) {
        self.animationDidStart = animationDidStart
        self.discImageView.layer.removeAllAnimations()
        self.setUpAnimation(fromValue:fromValue)
        if MusicPlayManager.shared.isPlayingMusic {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
