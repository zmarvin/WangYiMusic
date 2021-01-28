//
//  SearchRxAPI.swift
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/28.
//

import Foundation
import RxSwift
import SwiftyJSON

class SearchRxAPI: EMBaseRxAPI {
    func get_hotSearch() -> Single<[HotSearchModel]>{
        func jsonToModel(data:Data) throws -> [HotSearchModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["data"] as? [[String : Any]]
            guard let hotSearchModels = [HotSearchModel].deserialize(from: musics) as? [HotSearchModel] else {
                throw exampleError("Parsing error")
            }
            return hotSearchModels
        }
        return provider.rx.request(MyService.hotSearch).map {try jsonToModel(data: $0.data)}
    }
}
