//
//  File.swift
//  EnjoyMusic
//
//  Created by zz on 2019/3/29.
//  Copyright © 2019年 Mac. All rights reserved.
//

import Foundation
import HandyJSON

struct DiscoverMusicModel {
    
    var data  : [PlayListBaseModel]
    var ID    : DiscoverMusicSectionType
}

var sectionSortedArry : [DiscoverMusicSectionType]{
    return [
        .recommendMusic,
        .personalTailor,
        .recommendMV,
        .calendar,
        .voiceLive,
        .new_song,
        .newDishAlbum,
        .rankingList,
        .recommendDjprogram,
        .yuncunKTV,
        .djprogramCollection,
        .mvCollection
    ]
}

enum DiscoverMusicSectionType : String{
    case recommendMusic
    case recommendMV //choosyMusicMV 精选音乐视频
    case new_song //设置为"专属场景歌单"
    case recommendDjprogram // 8.0版本电台改为播客了 （title24小时播客）
    case djprogramCollection // 博客合辑
    case calendar
    case rankingList
    case personalTailor
    case newDishAlbum
    case mvCollection
    case yuncunKTV
    case voiceLive
    
    var sectionTitle : String{
        switch self {
        case .recommendMusic:
            return "推荐歌单"
        case .recommendMV:
            return "精选音乐视频"
        case .new_song:
            return "专属场景歌单"
        case .recommendDjprogram: // 8.0版本电台改为播客了
            return "24小时播客"
        case .djprogramCollection:
            return "播客合辑"
        case .mvCollection:
            return "视频合辑"
        case .calendar:
            return "音乐日历"
        case .rankingList:
            return "排行榜"
        case .personalTailor:
            return "私人订制"
        case .newDishAlbum:
            return ""
        case .yuncunKTV:
            return "云村KTV"
        case .voiceLive:
            return "语音直播"
        }
    }
    
    var sectionHeight : CGFloat{
        switch self {
        case .recommendMusic :
            return 160.0
        case .recommendMV :
            return 240
        case .rankingList:
            return 270
        case .newDishAlbum:
            return 300
        case .personalTailor:
            return 200
        case .yuncunKTV:
            return 180
        default:
            return 175
        }
    }
    
    var sectionHeaderHeight : CGFloat{
        switch self {
        case .personalTailor:
            return 70
        case .newDishAlbum:
            return 50
        case .rankingList:
            return 50
        default:
            return 50
        }
    }
    // sectionHeaderBtnTitle.count = 0不设置sectionHeaderBtn
    var sectionHeaderBtnTitle : String{
        switch self {
        case .personalTailor:
            return "▶播放"
        case .recommendMV:
            return "去推歌＞"
        case .calendar:
            return "今日2条＞"
        case .recommendDjprogram:
            return ""
        default:
            return "更多＞"
        }
    }

}



