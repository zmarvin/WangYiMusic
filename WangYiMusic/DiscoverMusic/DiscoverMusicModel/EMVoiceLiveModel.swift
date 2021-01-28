//
//  EMVoiceLiveModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/26.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import HandyJSON
class EMVoiceLiveModel: PlayListBaseModel {

    var subscribers : [Any]?
    var subscribed : Bool = false
    var creator : [Any]?
    var musics : [Music]?
    var trackIds : [Any]?
    var trackCount : Int = 0
    var updateTime : Int = 0
    var commentThreadId : String?
    var userId : Int = 0
    var adType : Int = 0
    var trackNumberUpdateTime : Int = 0
    var privacy : Int = 0
    var newImported : Bool = false
    var specialType : Int = 0
    var trackUpdateTime : Int = 0
    var highQuality :  Bool = false
    var coverImgId : Int = 0
    var createTime : Int = 0
    var subscribedCount : Int = 0
    var cloudTrackCount : Int = 0
    
    var status : Int = 0
    var descriptions : String?
    var ordered :  Bool = false
    var tags : [Any]?
    var coverImgUrl : String?

    var copywriter : String?
    var shareCount : Int = 0
    var coverImgId_str : String?
    var commentCount : Int = 0

    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.picUrl      <-- "coverImgUrl"
        mapper <<<
        self.descriptions      <-- "description"
    }
}
