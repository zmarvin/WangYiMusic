//
//  PlayListPlazaAllCategoryModel.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/3.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import HandyJSON

struct PlayListPlazaCategorySectionModel {
    var title : String = ""
    var attributedTitle : NSMutableAttributedString = NSMutableAttributedString()
    var data : [PlayListPlazaCategoryModel] = [PlayListPlazaCategoryModel]()
}

class PlayListPlazaCategoryModel: HandyJSON {
    required init() {}
    var id  = ""
    var name : String = ""
    var resourceCount : String = ""
    var imgId :  String = ""
    var imgUrl :  String = ""
    var type :  String = ""
    var category : String = ""
    var resourceType : Int = 0
    var hot : Bool = false
    var activity : Bool = false
}

enum PlayListPlazaCategoryEnum : Int{
    case language = 0 // 语种
    case style // 风格
    case scenes // 场景
    case emotion // 情感
    case theme // 主题
}
