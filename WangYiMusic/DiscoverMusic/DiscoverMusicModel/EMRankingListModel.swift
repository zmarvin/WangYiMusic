//
//  EMRankingListModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/21.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import HandyJSON

class EMRankingListCellModel: PlayListBaseModel {
    var coverImgUrl : String = ""
    var descriptions : String = ""
    var ToplistType : String = ""
    var specialType : Int = 0
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.descriptions <-- "description"
    }
}

class EMRankingListSectionModel: PlayListBaseModel {
    var sectionName : String = ""
    var sectionModels : [EMRankingListCellModel] = [EMRankingListCellModel]()
    
}

