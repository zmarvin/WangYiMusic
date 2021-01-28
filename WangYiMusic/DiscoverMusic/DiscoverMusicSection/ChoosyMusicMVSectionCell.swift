//
//  DiscoverMusicMVCell.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/18.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import IJKMediaFramework
import RxSwift
class ChoosyMusicMVSectionCell: UICollectionViewCell {
    
    var player : IJKMediaPlayback?
    var mvUrl : String = ""{
        didSet{
//            if self.contentView.subviews.count > 0 {return}
            guard self.player == nil else { return }
            guard let url = URL(string: mvUrl) else { return }
            self.createPlayer(with: url)
        }
    }
    let frostedGlassView : UIView = UIView()
    let titleLabel = UILabel()
    private let playerViewMark = 99
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizesSubviews = true
        self.cornersRound(radius: 8)
        self.frostedGlassView.backgroundColor = .white
        self.frostedGlassView.alpha = 0
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(self.frostedGlassView)
        self.frostedGlassView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func play() {
        guard let isPlay = self.player?.isPlaying() else {
            guard let url = URL(string: mvUrl) else { return }
            self.createPlayer(with: url)
            play()
            return
        }
        if !isPlay {
            self.player?.play()
        }
    }
    func stop() {
        guard let isPlay = self.player?.isPlaying() else { return }
        if isPlay {
            self.player?.stop()
        }
        
    }
    func pause() {
        guard let isPlay = self.player?.isPlaying() else { return }
        if isPlay {
            self.player?.pause()
        }
    }
    func createPlayer(with url: URL) {
        // 创建播放器
        let options = IJKFFOptions.byDefault()
        //开启硬解码 1是硬解 0是软解
        options?.setPlayerOptionValue("1", forKey: "videotoolbox")
        // 跳帧开关，如果cpu解码能力不足，可以设置成5，否则
        // 会引起音视频不同步，也可以通过设置它来跳帧达到倍速播放
        options?.setPlayerOptionIntValue(5, forKey: "framedrop")
        // 设置最大fps
        options?.setPlayerOptionIntValue(15, forKey: "max-fps")
        // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        options?.setPlayerOptionIntValue(15, forKey: "r")
        // 帧数
        options?.setPlayerOptionIntValue(5, forKey: "min-frames")
        // 开启环路滤波（0比48清楚，但解码开销大，48基本没有开启环路滤波，清晰度低，解码开销小）
        options?.setCodecOptionIntValue(Int64(IJK_AVDISCARD_ALL.rawValue), forKey: "skip_loop_filter")
        options?.setCodecOptionIntValue(Int64(IJK_AVDISCARD_ALL.rawValue), forKey: "skip_frame")
        // 关闭播放器缓冲
        options?.setPlayerOptionIntValue(0, forKey: "packet-buffering")
        
        self.player = IJKAVMoviePlayerController(contentURL:url)
        self.player?.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
        self.player?.scalingMode = IJKMPMovieScalingMode.aspectFill
        self.player?.shouldAutoplay = false
        self.player?.playbackVolume = 0 // 音量为0
        if let playerView = self.player?.view {
            if let thumbImageView = self.contentView.subviews.first as? UIImageView {
                thumbImageView.removeFromSuperview()
            }
            playerView.tag = playerViewMark
            self.contentView.insertSubview(playerView, at: 0)
            playerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
//            self.installMovieNotificationObservers()
        self.player?.prepareToPlay()
    }
    
    func destroyPlayer() {
        if let playerView = self.contentView.subviews.first,playerView.tag == playerViewMark {
            let image = self.player?.thumbnailImageAtCurrentTime()
            let thumbImageView = UIImageView(image: image)
            thumbImageView.contentMode = .scaleAspectFill
            self.contentView.insertSubview(thumbImageView, at: 0)
            thumbImageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            playerView.removeFromSuperview()
        }
        self.player?.shutdown()
        self.player = nil
    }

    // MARK: -- 监控视频播放
    func installMovieNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackDidFinish), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(mediaIsPreparedToPlayDidChange), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: self.player)
    }
    
    func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerLoadStateDidChange, object: self.player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerPlaybackDidFinish, object: self.player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: self.player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerLoadStateDidChange, object: self.player)
    }
    
    @objc func loadStateDidChange(notification:NSNotification) {
//        guard let loadState  = self.player?.loadState else{return}
    }
    @objc func moviePlayBackDidFinish(notification:NSNotification) {
        
    }
    @objc func mediaIsPreparedToPlayDidChange(notification:NSNotification) {
        print("mediaIsPreparedToPlayDidChange")
    }
    @objc func moviePlayBackStateDidChange(notification:NSNotification) {
        guard let state  = self.player?.playbackState else{return}
        switch state  {
            
        case .stopped:
            print("stopped")

        case .playing:
            print("playing")

        case .paused:
            print("paused")

        case .interrupted:
            print("interrupted")

        case .seekingForward:
            print("seekingForward")

        case .seekingBackward:
            print("seekingBackward")

        @unknown default:
            fatalError()
        }
    }
    
    deinit {
        self.removeMovieNotificationObservers()
    }
    
}

extension Reactive where Base: ChoosyMusicMVSectionCell {
    var mvUrl: Binder<String> {
        return Binder(self.base) { cell, value in
            cell.mvUrl = value
        }
    }
}
