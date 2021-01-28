//
//  MusicData.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class Music: NSObject, HandyJSON,NSCoding,NSSecureCoding{
    required override init() {}
    
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.id == rhs.id
    }
    var id : Int?
    var alia : [Any]?
    var name : String?
    var picUrl : String?
    var pic_str : String?
    var pic : Int?
    var more : MusicMoreInfoModel?
    var ar : [[String : String]]?
    var al : [String : String]?
    var creatorName : String{
        get{
            guard let tempAr = self.ar else { return "" }
            var name : String = ""
            if tempAr.count == 1 {
                name = tempAr[0]["name"] ?? ""
            }
            if tempAr.count == 2 {
                name = (tempAr[0]["name"] ?? "") + "/" + (tempAr[1]["name"] ?? "")
            }
            if let tempAl = self.al {
                name = name + " - " + (tempAl["name"] ?? "")
            }
            return name
        }
    }
    var attributedStringName : NSMutableAttributedString{
        get{
            guard let name = self.name else { return NSMutableAttributedString() }
            let prefix : String = name
            var suffix : String = ""
            
            if let al1 = self.alia as? [String]{
                if let value = al1.first {
                    suffix += "(" + "\(value)" + ")"
                }
            }

            let string = prefix + suffix
            let leftAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]
            let rightAttribute : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
            ]
            let attString = NSMutableAttributedString(string: string)
            attString.addAttributes(leftAttribute, range:NSRange(location: 0, length: prefix.count))
            attString.addAttributes(rightAttribute, range: NSRange(location: prefix.count, length: suffix.count))
            return attString
        }
    }
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.picUrl <-- "al.picUrl"
        mapper <<<
            self.pic_str <-- "al.pic_str"
        mapper <<<
            self.pic <-- "al.pic"
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(alia, forKey: "alia")
        coder.encode(name, forKey: "name")
        coder.encode(picUrl, forKey: "picUrl")
        coder.encode(pic_str, forKey: "pic_str")
        coder.encode(pic, forKey: "pic")
        coder.encode(more, forKey: "more")
        coder.encode(ar, forKey: "ar")
        coder.encode(al, forKey: "al")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        id = coder.decodeObject(forKey: "id") as? Int
        alia = coder.decodeObject(forKey: "alia") as? [Any]
        name = coder.decodeObject(forKey: "name") as? String
        picUrl = coder.decodeObject(forKey: "picUrl") as? String
        pic_str = coder.decodeObject(forKey: "pic_str") as? String
        more = coder.decodeObject(forKey: "more") as? MusicMoreInfoModel
        ar = coder.decodeObject(forKey: "ar") as? [[String : String]]
        al = coder.decodeObject(forKey: "al") as? [String : String]
    }
}

class MusicMoreInfoModel:NSObject, HandyJSON,NSCoding,NSSecureCoding {
    required override init() {}
    
    var id : Int = 0
    var url : String = ""
    var br : Int?
    var size : Int?
    var md5 : String?
    var code : Int?
    var expi : Int?
    var type : String?
    var gain : Int?
    var fee : Int?
    var uf : String?
    var payed : Int?
    var flag : Int?
    var canExtend : Bool?

    static var supportsSecureCoding: Bool{
        return true
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(url, forKey: "url")
        coder.encode(br, forKey: "br")
        coder.encode(size, forKey: "size")
        coder.encode(md5, forKey: "md5")
        coder.encode(code, forKey: "code")
        coder.encode(expi, forKey: "expi")
        coder.encode(type, forKey: "type")
        coder.encode(gain, forKey: "gain")
        coder.encode(fee, forKey: "fee")
        coder.encode(uf, forKey: "uf")
        coder.encode(payed, forKey: "payed")
        coder.encode(flag, forKey: "flag")
        coder.encode(canExtend, forKey: "canExtend")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
        url = coder.decodeObject(forKey: "url") as? String ?? ""
        br = coder.decodeObject(forKey: "br") as? Int
        size = coder.decodeObject(forKey: "size") as? Int
        md5 = coder.decodeObject(forKey: "md5") as? String
        code = coder.decodeObject(forKey: "code") as? Int
        expi = coder.decodeObject(forKey: "expi") as? Int
        type = coder.decodeObject(forKey: "type") as? String
        gain = coder.decodeObject(forKey: "gain") as? Int
        fee = coder.decodeObject(forKey: "fee") as? Int
        uf = coder.decodeObject(forKey: "uf") as? String
        payed = coder.decodeObject(forKey: "payed") as? Int
        flag = coder.decodeObject(forKey: "flag") as? Int
        canExtend = coder.decodeObject(forKey: "canExtend") as? Bool
    }
}

class PlayListBaseModel :NSObject, HandyJSON{
    required override init() {}
    
    var id : Int = 0
    var name : String = ""
    var picUrl : String = ""
    var playCount : Int = 0
    
    func mapping(mapper: HelpingMapper) {}

}

class Song: HandyJSON {
    required init() {}
    var id : Int = 0
    var name : String = ""
    
    var no : String?
    var ftype : String?
    var rtype : String?
    var dayPlays : String?
    var copyright : String?
    var fee : String?
    var duration : String?
    var rurl : String?
    var artists : [Artists]?
    var album : Album?
    var audition : String?
    var position : String?
    var mMusic : Dictionary<String,Any>?
    var starredNum : String?
    var mvid : String?
    var transName : String?
    var bMusic : Dictionary<String,Any>?
    var hearTime : String?
    var hMusic : Dictionary<String,Any>?
    var starred : String?
    var copyrightId : String?
    var rtUrls : String?
    var crbt : String?
    var ringtone : String?
    var alias : Dictionary<String,Any>?
    var popularity : String?
    var score : String?
    var mp3Url : String?
    var playedNum : String?
    var rtUrl : String?
    var sign : String?
    var status : String?
    var disc : String?
    var lMusic : Dictionary<String,Any>?
    var privilege : Dictionary<String,Any>?
    var copyFrom : String?

    
}

class Artists: HandyJSON{
    required init() {}

    var musicSize : Int?
    var picId : Int?
    var img1v1Url : String?
    var id : String?
    var name : String?
    var picUrl : Bool?
    var albumSize : Int?
    var briefDesc : Int?
    var trans : Bool?
    var img1v1Id : String?
    var alias : String?
    
}

class Album: HandyJSON{
    required init() {}

    var description : String?
    var artists : Artists?
    var tags : String?
    var status : String?
    var company : String?
    var songs : String?
    var id : String?
    var name : String?
    var type : String?
    var companyId : String?
    var pic : String?
    var picId : String?
    var blurPicUrl : String?
    var briefDesc : String?
    var commentThreadId : String?
    var alias : Dictionary<String, Any>?
    var artist :Artists?
    var size : String?
    var publishTime : String?
    var copyrightId : String?
    var picUrl : String?
    var subType : String?
    var picId_str : String?
    var transName : String?

}

class RecommendMV : PlayListBaseModel{
    required init() {}
    
    var duration : String?
    var subed : Bool = false
    var artists : [Any]?
    var artistName : String?
    var artistId : Int = 0
    @objc dynamic var mvUrl : String = ""
    var cover : String = ""
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<<
            self.picUrl <-- "cover"
    }
}
