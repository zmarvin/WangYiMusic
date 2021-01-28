//
//  EMPersonalTailorModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/22.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class EMPersonalTailorModel: PlayListBaseModel {
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.picUrl <-- "album.picUrl"
//        mapper <<<
//            self.name <-- "artists[0].name"
    }
}

class EMPersonalTailorSectionModel: PlayListBaseModel {
    typealias InnerRows = [EMPersonalTailorModel]
    var sectionModels : [InnerRows] = [InnerRows]()
    var sectionName : String = ""
}
