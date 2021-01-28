//
//  MVInfoModel.swift
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/28.
//

import Foundation
import HandyJSON

class MVInfoModel : HandyJSON{
    required init() {}

    var id : Int?
    var url : String = ""
    var r : String?
    var size : String?
    var md5 : String?
    var code : String?
    var expi : String?
    var fee : String?
    var mvFee : String?
    var st : String?
    var promotionVo : String?
    var msg : String?
    
    
    var name : String?

    var artistId : Int = 0
    var artistName : String?
    var briefDesc : String?
    var desc : String?
    var cover : String?
    var coverId : Int?
    
    var playCount : Int?
    var subCount : Int?
    var shareCount : Int?
    var likeCount : Int?
    var commentCount : Int?
    var duration : Int?
    var nType : Int?
    var publishTime : String?
    var brs : Brs?
    var isReward : Bool?
    var commentThreadId : String?
}

class Brs: HandyJSON {
    required init() {}
    var p480 : String?
    var p240 : String?
    var p720 : String?
    var p1080 : String?

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.p480 <-- "480"
        mapper <<<
            self.p240 <-- "240"
        mapper <<<
            self.p720 <-- "720"
        mapper <<<
            self.p1080 <-- "1080"
    }
}
