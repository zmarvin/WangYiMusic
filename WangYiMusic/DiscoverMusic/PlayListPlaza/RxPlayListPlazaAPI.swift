//
//  RxPlayListPlazaAPI.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
 
import RxSwift

class RxPlayListPlazaAPI: EMBaseRxAPI{

    func get_playList(limit: Int,cat:String?) -> Single<[PlayListPlazaModel]>{
        func jsonToModel(data:Data) throws -> [PlayListPlazaModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["playlists"] as? [[String : Any]]
            
            guard let models = [PlayListPlazaModel].deserialize(from: musics) as? [PlayListPlazaModel]  else {
                throw exampleError("Parsing error")
            }
            return models
        }
        return provider.rx.request(MyService.playlist(limit: limit,cat: cat)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_boutiquePlayList(limit: Int,cat:String?) -> Single<[PlayListPlazaModel]>{
        func jsonToModel(data:Data) throws -> [PlayListPlazaModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["playlists"] as? [[String : Any]]
            guard let models = [PlayListPlazaModel].deserialize(from: musics) as? [PlayListPlazaModel]  else {
                throw exampleError("Parsing error")
            }
            
            return models
        }
        return provider.rx.request(MyService.playlist_boutique(limit: limit,cat: cat)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_playListAllCategory() -> Single<[PlayListPlazaCategorySectionModel]>{
        func jsonToModel(data:Data) throws -> [PlayListPlazaCategorySectionModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["sub"] as? [[String : Any]]
            guard let models = [PlayListPlazaCategoryModel].deserialize(from: musics) as? [PlayListPlazaCategoryModel]  else {
                throw exampleError("Parsing error")
            }
            
            var sectionModels = [PlayListPlazaCategorySectionModel]()
            if let categorys = tempJson?["categories"] as? [String : Any] {
                for (key , element) in categorys{
                    var sectionModel = PlayListPlazaCategorySectionModel()
                    if let e = element as? String {
                        sectionModel.title = e
                    }
                    sectionModel.data.append(contentsOf: models.filter{$0.category == key})
                    sectionModels.append(sectionModel)
                    sectionModels.sort(by: {$0.data.first!.category < $1.data.first!.category})
                }
            }
            return sectionModels
        }
        return provider.rx.request(MyService.playlistCategory).map {try jsonToModel(data: $0.data)}
    }
    
    func get_playListAllBoutiqueCategory() -> Single<[PlayListPlazaCategoryModel]>{
        func jsonToModel(data:Data) throws -> [PlayListPlazaCategoryModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["tags"] as? [[String : Any]]
            guard let models = [PlayListPlazaCategoryModel].deserialize(from: musics) as? [PlayListPlazaCategoryModel]  else {
                throw exampleError("Parsing error")
            }
            return models
        }
        return provider.rx.request(MyService.playlist_boutiqueCategory).map {try jsonToModel(data: $0.data)}
    }
}
