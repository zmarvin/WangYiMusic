//
//  EMCalendarModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class EMCalendarModel : PlayListBaseModel{
    required init() {}
    
//    var id : Int?
    var eventType : String = ""
    var tag : String = ""
    var url : String = ""
    var title : String = ""
    var imgUrl : String = ""
    var resourceId : String = ""
    
    override func mapping(mapper: HelpingMapper) {}

}
