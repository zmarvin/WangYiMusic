//
//  EMNewDishAlbumModel.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/22.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class EMNewDishAlbumModel: PlayListBaseModel {
    var song : Song = Song()
}
class EMNewDishAlbumSectionModel: PlayListBaseModel {
    typealias InnerRows = [EMNewDishAlbumModel]
    var sectionModels : [InnerRows] = [InnerRows]()
    var sectionName : String = ""
}
