//
//  MusicPlayManager.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/7.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import StreamingKit
import RxCocoa
import RxSwift

class MusicPlayManager : NSObject{
    static let shared = MusicPlayManager()
    let disposeBag = DisposeBag()
    let API = MusicPlayRxAPI()
    @objc dynamic var currentPlayingMusic:Music?{
        didSet{
            guard let newId = currentPlayingMusic?.id else { return }
            guard let oldId = oldValue?.id else { return }
            if newId == oldId {return}
            self.isSwitchMusic = true
            self.playMusic()
        }
    }
    var currentPlayingMusics:[Music]?
    var currentPlayingIndex : Int{
        guard let musics = currentPlayingMusics, let music = currentPlayingMusic else { return 0 }
        return musics.firstIndex(where: {$0 == music}) ?? 0
    }
    
    lazy var audioPlayer: STKAudioPlayer = {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        let audioPlayer = STKAudioPlayer(options: options)
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
        audioPlayer.delegate = self
        return audioPlayer
    }()
    
    private var isSwitchMusic = false
    @objc dynamic var isPlaying : Bool = false
    
    override init() {
        super.init()
        self.audioPlayer.rx.observe(\.state).map{$0 == [.playing,.running] || $0 == [.buffering,.running]}.subscribe(onNext: {[unowned self] isPlaying in
            self.isPlaying = isPlaying
        }).disposed(by: disposeBag)
    }
    
    func playMusic() {
        
        if let info = self.currentPlayingMusic?.more {
            self.play(url: info.url)
            return
        }
        
        self.getMusicInfo(completed: {info in
            self.play(url: info.url)
        }, failure: {err in
        })
    }
    
    func play(url:String) {
        let player = self.audioPlayer
        if player.state == .paused,!self.isSwitchMusic{
            player.resume()
        }else if player.state == .paused,self.isSwitchMusic{
            player.play(url)
            player.pause()
            self.isSwitchMusic = false
        }else{
            player.play(url)
            self.isSwitchMusic = false
        }
    }
    
    func stopMusic() {
        self.audioPlayer.pause()
    }
    
    func playNextMusic() {
        guard let nextMusic = self.nextMusic() else { return }
        self.currentPlayingMusic = nextMusic
    }
    
    func playLastMusic() {
        guard let lastMusic = self.lastMusic() else { return }
        self.currentPlayingMusic = lastMusic
    }
    
    func getMusicInfo(completed:((MusicMoreInfoModel)->Void)?,failure:((Error)->Void)?) {
        API.get_music_url(id: self.currentPlayingMusic?.id ?? 0).subscribe(onSuccess: {[unowned self] info in
            self.currentPlayingMusic?.more = info
            completed?(info)
        }, onFailure: {err in
            failure?(err)
        }).disposed(by: disposeBag)
    }
    
    var loopType : PlayMusicControlLoopType = .cycle
    private func nextMusic() -> Music?{
        return switchMusic { (index, list) -> Music? in
            if index == list.count-1{
                return list.first
            }else{
                return list[index+1]
            }
        }
    }
    
    private func lastMusic() -> Music?{
        return switchMusic { (index, list) -> Music? in
            if index == 0{
                return list.last
            }else{
                return list[index-1]
            }
        }
    }
    
    func switchMusic(cycle:(Int,[Music])->Music?) -> Music? {
        guard let list = currentPlayingMusics, list.count > 0 else { return nil }
        var result : Music?
        switch loopType {
        case .single:
            result = currentPlayingMusic
        case .random:
            result = list[Int(arc4random_uniform(UInt32(list.count)))]
        case .cycle:
            guard let cMusic = currentPlayingMusic else { return nil }
            guard let index = list.firstIndex(where: {$0 == cMusic}) else { return nil }
            result = cycle(index,list)
        }
        return result
    }
    
    enum PlayMusicControlLoopType {
        case single
        case random
        case cycle
        
        mutating func next() {
            switch self {
            case .single:
                self = .random
            case .random:
                self = .cycle
            case .cycle:
                self = .single
            }
        }
    }
    
    @discardableResult
    func archiveTodisk() -> Bool{
        guard let currentPlayingMusic = MusicPlayManager.shared.currentPlayingMusic else { return false}
        guard let currentPlayingMusics = MusicPlayManager.shared.currentPlayingMusics else { return false}
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let currentPlayingMusicFilePath = (file as NSString).appendingPathComponent("CurrentPlayingMusic.data")
        let currentPlayingMusicsFilePath = (file as NSString).appendingPathComponent("CurrentPlayingMusics.data")

        let isSuccess1 = NSKeyedArchiver.archiveRootObject(currentPlayingMusic, toFile: currentPlayingMusicFilePath)
        let isSuccess2 = NSKeyedArchiver.archiveRootObject(currentPlayingMusics, toFile: currentPlayingMusicsFilePath)
        let isArchiveMusicSuccess = isSuccess1 && isSuccess2
        if isArchiveMusicSuccess {
            print("写入成功")
        }else{
            print("写入失败")
        }
        return isArchiveMusicSuccess
    }
    func unArchiveFromdisk() -> Bool{
        var isUnArchiveMusicSuccess = false
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let currentPlayingMusicFilePath = (file as NSString).appendingPathComponent("CurrentPlayingMusic.data")
        let currentPlayingMusicsFilePath = (file as NSString).appendingPathComponent("CurrentPlayingMusics.data")
        
        do {
            let musicData = try Data(contentsOf: URL(fileURLWithPath: currentPlayingMusicFilePath))
            let music = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(musicData) as? Music
            MusicPlayManager.shared.currentPlayingMusic = music
            
            let musicsData = try Data(contentsOf: URL(fileURLWithPath: currentPlayingMusicsFilePath))
            let musics = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(musicsData) as? [Music]
            MusicPlayManager.shared.currentPlayingMusics = musics
            isUnArchiveMusicSuccess = true
        } catch {
            print("获取CurrentPlayingMusic数据失败: \(error)")
            isUnArchiveMusicSuccess = false
        }
        return isUnArchiveMusicSuccess
    }
}
extension MusicPlayManager : STKAudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
//        print("queueItemId:\(queueItemId)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print("errorCode:\(errorCode)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
//        print("queueItemId:\(queueItemId)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        print("stateChanged:\(state),previousState:\(previousState)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        print("播放结束,progress:\(progress),duration:\(duration)")
        switch stopReason {
        case .none:
            print("none")
        case .pendingNext:
            print("pendingNext")
        case .userAction:
            print("userAction")
        case .disposed:
            print("disposed")
        case .eof:
            self.playNextMusic()
            print("eof")
        case .error:
            print("error")
        @unknown default:
            fatalError()
        }
    }
}




