//
//  RxDiscoverMusicProcessor.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift

class RxDiscoverMusicAPI :EMBaseRxAPI{
    lazy var get_superZip = Single.zip(get_zip1, get_zip2).map { (arg0) -> [DiscoverMusicModel] in
        let ((m1, m2, m3, m4, m5, m6, m7, m8), (n1, n2, n3, n4)) = arg0
        return [m1, m2, m3, m4, m5, m6, m7, m8, n1, n2, n3, n4]
    }
    
    lazy var get_zip1 = Single.zip(
        get_Personalized(),
        get_PersonalTailor(),
        get_newsong(),
        get_Calendar(),
        get_djprogram(),
        get_voiceLive(),
        get_RankingList(),
        get_mvCollection()
    )
    
    lazy var get_zip2 = Single.zip(
        get_yuncunKTV(),
        get_New_mv(),
        get_NewDishAlbum(),
        get_djprogramCollection()
    )

    func get_Banner() -> Single<[EMBannerModel]>{
        func jsonToModel(data:Data) throws -> [EMBannerModel]{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["banners"] as? [[String : Any]]
            
            guard let bannerModels = [EMBannerModel].deserialize(from: musics) as? [EMBannerModel]  else {
                throw exampleError("Parsing error")
            }
            return bannerModels
        }
        
        return provider.rx.request(MyService.banner(type:2)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_Personalized() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["result"] as? [[String : Any]]
            
            guard let models = [PlayListBaseModel].deserialize(from: musics) as? [PlayListBaseModel]  else {
                throw exampleError("Parsing error")
            }
            
            return DiscoverMusicModel(data: models, ID: .recommendMusic)
        }
        return provider.rx.request(MyService.personalized(limit: 6)).map {try jsonToModel(data: $0.data)}
    }
    
    let disposeBag = DisposeBag()
    func get_New_mv() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["data"] as? [[String : Any]]
            
            guard let recommendmvs = [RecommendMV].deserialize(from: musics) as? [RecommendMV]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: recommendmvs, ID: .recommendMV)
        }
        return provider.rx.request(MyService.new_mv(limit: 6)).map {try jsonToModel(data: $0.data)}
            .do(onSuccess: { discoverMusicModel in// 再请求获取到mvUrl
                guard let recommendmvs = discoverMusicModel.data as? [RecommendMV] else {return}
                for recommendmv in recommendmvs{
                    self.get_MVUrl(id: recommendmv.id)
                        .subscribe(onSuccess: { mv in
                            recommendmv.mvUrl = mv.url
                        }).disposed(by: self.disposeBag)
                }
            })
    }
    
    func get_MVUrl(id:Int) -> Single<MVInfoModel> {
        func jsonToModel(data:Data) throws -> MVInfoModel{
            let mvJson = JSON(data).dictionaryObject?["data"] as? [String : Any]
            guard let mv = MVInfoModel.deserialize(from: mvJson) else {
                throw exampleError("Parsing error")
            }
            return mv
        }
        return provider.rx.request(MyService.mv_url(id: id)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_Calendar() -> Single<DiscoverMusicModel> {
        func jsonToModel() -> DiscoverMusicModel?{
            guard let path = Bundle.main.path(forResource: "MusicCalendars", ofType: "json") else { return nil}
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let tempJson = JSON(data).dictionaryObject
            let calendarEvents = tempJson?["data"] as? [String : Any]
            let calendars = calendarEvents?["calendarEvents"] as? [[String : Any]]
            guard let calendarsModels = [EMCalendarModel].deserialize(from: calendars) as? [EMCalendarModel] else{
                return nil
            }
            return DiscoverMusicModel(data: calendarsModels,ID:.calendar)
        }
        return Single<DiscoverMusicModel>.create { (observer) -> Disposable in
            if let models = jsonToModel() {
                observer(.success(models))
            }else {
                observer(.failure(self.exampleError("Parsing error")))
            }
            return Disposables.create()
        }
    }
    
    func get_newsong() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["result"] as? [[String : Any]]

            guard let models = [PlayListBaseModel].deserialize(from: musics) as? [PlayListBaseModel]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: models,ID:.new_song)
        }
        return provider.rx.request(MyService.personalized_newsong).map {try jsonToModel(data: $0.data)}
    }
    
//    func get_newsong() -> Single<DiscoverMusicModel>{
//        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
//            let tempJson = JSON(data).dictionaryObject
//            let musics = tempJson?["playlists"] as? [[String : Any]]
//
//            guard let models = [PlayListBaseModel].deserialize(from: musics) as? [PlayListBaseModel]  else {
//                throw exampleError("Parsing error")
//            }
//            return DiscoverMusicModel(data: models,ID:.new_song)
//        }
//        return provider.rx.request(MyService.playlist(limit: 6,cat: "官方")).map {try jsonToModel(data: $0.data)}
//    }
    
    func get_djprogram() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["result"] as? [[String : Any]]
            
            guard let models = [PlayListBaseModel].deserialize(from: musics) as? [PlayListBaseModel]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: models,ID:.recommendDjprogram)
        }
        return provider.rx.request(MyService.personalized_djprogram).map {try jsonToModel(data: $0.data)}
    }
    
    func get_djprogramCollection() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["result"] as? [[String : Any]]
            
            guard let models = [PlayListBaseModel].deserialize(from: musics) as? [PlayListBaseModel]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: models,ID:.djprogramCollection)
        }
        return provider.rx.request(MyService.personalized_djprogram).map {try jsonToModel(data: $0.data)}
    }
    
    func get_mvCollection() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["data"] as? [[String : Any]]
            
            guard let models = [RecommendMV].deserialize(from: musics) as? [RecommendMV]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: models, ID: .mvCollection)
        }
        return provider.rx.request(MyService.exclusive_mv(limit:6)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_voiceLive() -> Single<DiscoverMusicModel> {
        func jsonToModel(data:Data) throws -> DiscoverMusicModel{
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["playlists"] as? [[String : Any]]
            
            guard let models = [EMVoiceLiveModel].deserialize(from: musics) as? [EMVoiceLiveModel]  else {
                throw exampleError("Parsing error")
            }
            return DiscoverMusicModel(data: models,ID:.voiceLive)
        }
        return provider.rx.request(MyService.playlist(limit: 6, cat: nil)).map {try jsonToModel(data: $0.data)}
    }
    
    func get_yuncunKTV() -> Single<DiscoverMusicModel> {
        func jsonToModel() -> DiscoverMusicModel?{
            let tempJson = [
                "data":[
                    [
                        "name":"这是一个跑调的房间",
                        "picUrl":"http://p1.music.126.net/2zSNIqTcpHL2jIvU6hG0EA==/109951162868128395.jpg"
                    ],
                    [
                        "name":"五音不全练歌房",
                        "picUrl":"http://p1.music.126.net/netkEfdMmd6Z2Ebn9X-NCg==/109951164845336309.jpg"
                    ],
                    [
                        "name":"清唱（害挺优质的）",
                        "picUrl":"http://p1.music.126.net/iuG0alLupjFnIU3qWLoxlw==/109951165593123780.jpg"
                    ],
                    [
                        "name":"奶狗集合地",
                        "picUrl":"http://p3.music.126.net/jOGhaHqosdCQ2ksKIXhX0A==/528865138953427.jpg"
                    ],
                    [
                        "name":"练歌房",
                        "picUrl":"http://p1.music.126.net/VeCapqiqycHvjW6WSP8pHQ==/109951163124709068.jpg"
                    ],
                    [
                        "name":"让我告诉你什么叫神...",
                        "picUrl":"http://p1.music.126.net/flT89Ub7QDhCYEPDVVnHPA==/5740550208624677.jpg"
                    ],
                    
                ]
            ]
            let musics = tempJson["data"]
            guard let recommendmvs = [EMYuncunKTVModel].deserialize(from: musics) as? [EMYuncunKTVModel] else {
                    return nil
            }
            
            return DiscoverMusicModel(data: recommendmvs, ID: .yuncunKTV)
        }
        return Single<DiscoverMusicModel>.create { (observer) -> Disposable in
            if let models = jsonToModel() {
                observer(.success(models))
            }else {
                observer(.failure(self.exampleError("Parsing error")))
            }
            return Disposables.create()
        }
    }
    
    func get_NewDishAlbum() -> Single<DiscoverMusicModel>{
        func jsonToModel() -> DiscoverMusicModel?{
            
            guard let path = Bundle.main.path(forResource: "NewDishAlbum", ofType: "json") else {
                return nil
            }
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["result"] as? [[String : Any]]

            guard let newDishAlbumModels = [EMNewDishAlbumModel].deserialize(from: musics) as? [EMNewDishAlbumModel]  else {
                return nil
            }
            typealias InnerRows = [EMNewDishAlbumModel]
            
            var rowModels1 = InnerRows()
            var rowModels2 = InnerRows()

            var rowModels2_1 = InnerRows()
            var rowModels2_2 = InnerRows()

            var rowModels3_1 = InnerRows()
            var rowModels3_2 = InnerRows()
            var rowModels3_3 = InnerRows()

            var rowModels4_1 = InnerRows()

            for (i,tempModel) in newDishAlbumModels.enumerated(){
                switch i {
                case 0...5:
                    switch i {
                    case 0...2:
                        rowModels1.append(tempModel)
                    case 3...5:
                        rowModels2.append(tempModel)
                    default:break
                    }
                case 6...11:
                    switch i {
                    case 6...8:
                        rowModels2_1.append(tempModel)
                    case 9...11:
                        rowModels2_2.append(tempModel)
                    default:break
                    }
                case 12...20:
                    switch i {
                    case 12...14:
                        rowModels3_1.append(tempModel)
                    case 15...17:
                        rowModels3_2.append(tempModel)
                    case 18...20:
                        rowModels3_3.append(tempModel)
                    default:break
                    }
                case 21...23:
                    rowModels4_1.append(tempModel)
                default:
                    break
                }
            }
            
            let innerSectionModel1 = EMNewDishAlbumSectionModel()
            innerSectionModel1.sectionName = "新歌"
            innerSectionModel1.sectionModels.append(rowModels1)
            innerSectionModel1.sectionModels.append(rowModels2)
            
            let innerSectionModel2 = EMNewDishAlbumSectionModel()
            innerSectionModel2.sectionName = "新碟"
            innerSectionModel2.sectionModels.append(rowModels2_1)
            innerSectionModel2.sectionModels.append(rowModels2_2)

            let innerSectionModel3 = EMNewDishAlbumSectionModel()
            innerSectionModel3.sectionName = "数字专辑"
            innerSectionModel3.sectionModels.append(rowModels3_1)
            innerSectionModel3.sectionModels.append(rowModels3_2)
            innerSectionModel3.sectionModels.append(rowModels3_3)
                                     
            let innerSectionModel4 = EMNewDishAlbumSectionModel()
            innerSectionModel4.sectionName = "推荐以下新歌 赚双倍云贝"
            innerSectionModel4.sectionModels.append(rowModels4_1)
            
            var newDishAlbumSectionModels = [EMNewDishAlbumSectionModel]()
            newDishAlbumSectionModels.append(innerSectionModel1)
            newDishAlbumSectionModels.append(innerSectionModel2)
            newDishAlbumSectionModels.append(innerSectionModel3)
            newDishAlbumSectionModels.append(innerSectionModel4)
            return DiscoverMusicModel(data: newDishAlbumSectionModels, ID: .newDishAlbum)
        }
        return Single<DiscoverMusicModel>.create { (observer) -> Disposable in
            if let models = jsonToModel() {
                observer(.success(models))
            }else {
                observer(.failure(self.exampleError("Parsing error")))
            }
            return Disposables.create()
        }
    }
    func get_PersonalTailor() -> Single<DiscoverMusicModel>{
        func jsonToModel() -> DiscoverMusicModel?{
            guard let path = Bundle.main.path(forResource: "PersonalTailor", ofType: "json") else { return nil}
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["data"] as? [[String : Any]]
            
            guard let personalTailorTempModels = [EMPersonalTailorModel].deserialize(from: musics) as? [EMPersonalTailorModel] else{
                return nil
            }
            typealias InnerRows = [EMPersonalTailorModel]

            var rowModels1 = InnerRows()
            var rowModels2 = InnerRows()
            var rowModels3 = InnerRows()
            var rowModels4 = InnerRows()

            var rowModels2_1 = InnerRows()
            var rowModels2_2 = InnerRows()
            var rowModels2_3 = InnerRows()
            var rowModels2_4 = InnerRows()

            var rowModels3_1 = InnerRows()
            var rowModels3_2 = InnerRows()
            var rowModels3_3 = InnerRows()
            var rowModels3_4 = InnerRows()

            var rowModels4_1 = InnerRows()
            var rowModels4_2 = InnerRows()
            var rowModels4_3 = InnerRows()
            var rowModels4_4 = InnerRows()

            for (i,tempModel) in personalTailorTempModels.enumerated(){
                switch i {
                case 0...11:
                    switch i {
                    case 0...2:
                        rowModels1.append(tempModel)
                    case 3...5:
                        rowModels2.append(tempModel)
                    case 6...8:
                        rowModels3.append(tempModel)
                    case 9...11:
                        rowModels4.append(tempModel)
                    default:break
                    }
                case 12...23:
                    switch i {
                    case 12...14:
                        rowModels2_1.append(tempModel)
                    case 15...17:
                        rowModels2_2.append(tempModel)
                    case 18...20:
                        rowModels2_3.append(tempModel)
                    case 21...23:
                        rowModels2_4.append(tempModel)
                    default:break
                    }
                case 24...35:
                    switch i {
                    case 24...26:
                        rowModels3_1.append(tempModel)
                    case 27...29:
                        rowModels3_2.append(tempModel)
                    case 30...32:
                        rowModels3_3.append(tempModel)
                    case 33...35:
                        rowModels3_4.append(tempModel)
                    default:break
                    }
                case 36...47:
                    switch i {
                    case 36...38:
                        rowModels4_1.append(tempModel)
                    case 39...41:
                        rowModels4_2.append(tempModel)
                    case 42...44:
                        rowModels4_3.append(tempModel)
                    case 45...47:
                        rowModels4_4.append(tempModel)
                    default:break
                    }
                default:
                    break
                }
            }
            
            let innerSectionModel1 = EMPersonalTailorSectionModel()
            innerSectionModel1.sectionName = "欧美流行精选"
            innerSectionModel1.sectionModels.append(rowModels1)
            innerSectionModel1.sectionModels.append(rowModels2)
            innerSectionModel1.sectionModels.append(rowModels3)
            innerSectionModel1.sectionModels.append(rowModels4)
            
            let innerSectionModel2 = EMPersonalTailorSectionModel()
            innerSectionModel2.sectionName = "爵士的慵懒溢出来了"
            innerSectionModel2.sectionModels.append(rowModels2_1)
            innerSectionModel2.sectionModels.append(rowModels2_2)
            innerSectionModel2.sectionModels.append(rowModels2_3)
            innerSectionModel2.sectionModels.append(rowModels2_4)

            let innerSectionModel3 = EMPersonalTailorSectionModel()
            innerSectionModel3.sectionName = "不可错过的欧美金曲"
            innerSectionModel3.sectionModels.append(rowModels3_1)
            innerSectionModel3.sectionModels.append(rowModels3_2)
            innerSectionModel3.sectionModels.append(rowModels3_3)
            innerSectionModel3.sectionModels.append(rowModels3_4)
            
            let innerSectionModel4 = EMPersonalTailorSectionModel()
            innerSectionModel4.sectionName = "节奏担当 电音精选"
            innerSectionModel4.sectionModels.append(rowModels4_1)
            innerSectionModel4.sectionModels.append(rowModels4_2)
            innerSectionModel4.sectionModels.append(rowModels4_3)
            innerSectionModel4.sectionModels.append(rowModels4_4)
            
            var personalTailorSectionModels = [EMPersonalTailorSectionModel]()
            personalTailorSectionModels.append(innerSectionModel1)
            personalTailorSectionModels.append(innerSectionModel2)
            personalTailorSectionModels.append(innerSectionModel3)
            personalTailorSectionModels.append(innerSectionModel4)
            return DiscoverMusicModel(data: personalTailorSectionModels, ID: .personalTailor)
        }
        return Single<DiscoverMusicModel>.create { (observer) -> Disposable in
            if let models = jsonToModel() {
                observer(.success(models))
            }else {
                observer(.failure(self.exampleError("Parsing error")))
            }
            return Disposables.create()
        }
    }
    
    func get_RankingList() -> Single<DiscoverMusicModel>{
        func jsonToModel() -> DiscoverMusicModel?{
            guard let path = Bundle.main.path(forResource: "RankingList", ofType: "json") else { return nil}
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            let tempJson = JSON(data).dictionaryObject
            let musics = tempJson?["list"] as? [[String : Any]]
            
            guard let rankingListTempModels = [EMRankingListCellModel].deserialize(from: musics) as? [EMRankingListCellModel] else{
                return nil
            }
                
            let sectionModel1 = EMRankingListSectionModel()
            let sectionModel2 = EMRankingListSectionModel()
            let sectionModel3 = EMRankingListSectionModel()
            let sectionModel4 = EMRankingListSectionModel()
            let sectionModel5 = EMRankingListSectionModel()
            
            for (i,tempModel) in rankingListTempModels.enumerated(){
                switch i {
                case 0...2:
                    sectionModel1.sectionModels.append(tempModel)
                    sectionModel1.sectionName = tempModel.name + " >"
                    print("")
                case 3...5:
                    sectionModel2.sectionModels.append(tempModel)
                    sectionModel2.sectionName = tempModel.name + " >"
                    print("")
                case 6...8:
                    sectionModel3.sectionModels.append(tempModel)
                    sectionModel3.sectionName = tempModel.name + " >"
                    print("")
                case 9...11:
                    sectionModel4.sectionModels.append(tempModel)
                    sectionModel4.sectionName = tempModel.name + " >"
                    print("")
                case 12...14:
                    sectionModel5.sectionModels.append(tempModel)
                    sectionModel5.sectionName = tempModel.name + " >"
                    print("")
                default:
                    break
                }
            }
            
            var rankingListModels = [EMRankingListSectionModel]()
            rankingListModels.append(sectionModel1)
            rankingListModels.append(sectionModel2)
            rankingListModels.append(sectionModel3)
            rankingListModels.append(sectionModel4)
            rankingListModels.append(sectionModel5)
            return DiscoverMusicModel(data: rankingListModels, ID: .rankingList)
        }
        return Single<DiscoverMusicModel>.create { (observer) -> Disposable in
            if let models = jsonToModel() {
                observer(.success(models))
            }else {
                observer(.failure(self.exampleError("Parsing error")))
            }
            return Disposables.create()
        }
    }
}
