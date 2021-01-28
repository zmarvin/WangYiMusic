//
//  PlayListPlazaModel.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class PlayListPlazaModel: HandyJSON {
    required init() {}
    var id : Int = 0
    var name : String = ""
    var subscribers : [Any]?
    var subscribed : Bool = false
    var creator : Creator?
    var musics : [Music]?
//    var tracks : [[String:Any]]?
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
    
    var subscribedCount : String = ""
    var commentCount : String = ""
    var shareCount : String = ""
    
    var cloudTrackCount : Int = 0
    var playCount : String = ""
    var status : Int = 0
    var descriptions = ""
    var ordered :  Bool = false
    var tags : [Any]?
    var coverImgUrl = ""
    var copywriter = ""
    
    var coverImgId_str = ""
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.descriptions <-- "description"
        mapper <<<
            self.musics      <-- "tracks"
    }
}

class Creator: HandyJSON {
    required init() {}
    var nickname : String = ""
    var avatarUrl : String = ""
    var signature : String = ""
    var gender : String = ""
    var followed : String = ""
    var authStatus : String = ""
    
    var birthday : String = ""
    var userId : String = ""
    var description : String = ""
    var detailDescription : String = ""
    
    var city : String = ""
    var province : String = ""
    var defaultAvatar : String = ""
    
    var avatarImgId : String = ""
    var backgroundImgId : String = ""
    var backgroundUrl : String = ""
    
    var authority : String = ""
    var mutual : String = ""
}
