//
//  MusicPlayRxAPI.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/7.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

class MusicPlayRxAPI: EMBaseRxAPI {
    func get_music_url(id: Int) -> Single<MusicMoreInfoModel>{
        func jsonToModel(data:Data) throws -> MusicMoreInfoModel{
            let tempJson = JSON(data).dictionaryObject
            let subJson = tempJson?["data"] as? [[String : Any]]
            
            guard let models = [MusicMoreInfoModel].deserialize(from: subJson) as? [MusicMoreInfoModel],let model = models.first else {
                throw exampleError("Parsing error")
            }
            return model
        }
        return provider.rx.request(MyService.music_url(id: id)).map {try jsonToModel(data: $0.data)}
    }
}
