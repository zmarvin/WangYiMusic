//
//  EMBannerModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/12.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class EMBannerModel : HandyJSON{
    required init() {}
    
    var bannerId : String?
    var typeTitle : String?
    var pic : String = ""
    var url : String?
    var titleColor : String?
    var targetType : Int?
    var targetId : String?
    
    func mapping(mapper: HelpingMapper) {}

}
