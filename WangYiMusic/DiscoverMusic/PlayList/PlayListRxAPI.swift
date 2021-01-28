//
//  PlayListRxAPI.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
 

class PlayListRxAPI :EMBaseRxAPI{

    func get_playList_detail(id: Int) -> Single<PlayListPlazaModel>{
        func jsonToModel(data:Data) throws -> PlayListPlazaModel{
            let tempJson = JSON(data).dictionaryObject
            let subJson = tempJson?["playlist"] as? [String : Any]
            
            guard let model = PlayListPlazaModel.deserialize(from: subJson) else {
                throw exampleError("Parsing error")
            }
            return model
        }
        return provider.rx.request(MyService.playlist_detail(id: id)).map {try jsonToModel(data: $0.data)}
    }
}
