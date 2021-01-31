//
//  MyService.swift
//  EMDataModule
//
//  Created by zz on 2017/10/20.
//  Copyright © 2017年 zz. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire

public enum MyService {
    case zen
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id: Int, firstName: String, lastName: String)
    case showAccounts
    case personal_fm
    case personalized(limit: Int)
    case personalized_newsong
    case personal_mv
    case new_mv(limit: Int)
    case exclusive_mv(limit: Int) // 网易出品MV
    case personalized_djprogram // 推荐电台
    case banner(type:Int)
    
    case music_url(id: Int)
    case mv_url(id: Int)
    case playlist_boutique(limit: Int,cat:String?)
    
    case playlist(limit: Int,cat:String?)
    case playlist_detail(id: Int)
    
    case ranklist(idx:Int)
    case recommendSongs
    case simi_mv(mvid: Int)
    case comment_mv(id: Int)
    case event
    case calendar(startTime:String,endTime:String)
    case rankingList
    case hotSearch
    case playlistCategory
    case playlist_boutiqueCategory
}

extension MyService: TargetType {
    public var baseURL: URL {
        
        switch self {
        default:
#if targetEnvironment(simulator)
            return URL(string: "http://localhost:3000")!
#else
            return URL(string: "http://192.168.0.105:3000")!
#endif
        }
    }
    public var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .showUser(let id), .updateUser(let id, _, _):
            return "/users/\(id)"
        case .createUser(_, _):
            return "/users"
        case .showAccounts:
            return "/accounts"
        case .personal_fm:
            return "/personal_fm"
        case .personalized:
            return "/personalized"
        case .personalized_newsong:
            return "/personalized/newsong"
        case .personal_mv:
            return "/personalized/mv"
        case .new_mv:
            return "/mv/first"
        case .exclusive_mv:
            return "/mv/exclusive/rcmd"
        case .personalized_djprogram:
            return "/personalized/djprogram"
        case .banner:
            return "/banner"
        case .playlist_detail:
            return "/playlist/detail"
        case .music_url:
            return "/song/url"
        case .mv_url:
            return "/mv/url"
        case .ranklist:
            return "/top/list"
        case .recommendSongs:
            return "/recommend/songs"
        case .simi_mv:
            return "/simi/mv"
        case .comment_mv:
            return "/comment/mv"
        case .event:
            return "/event"
        case .calendar:
            return "/calendar"
        case .rankingList:
            return "/toplist"
        case .hotSearch:
            return "/search/hot/detail"
        case .playlist_boutique:
            return "/top/playlist/highquality"
        case .playlist:
            return "/top/playlist"
        case .playlistCategory:
            return "/playlist/catlist"
        case .playlist_boutiqueCategory:
            return "/playlist/highquality/tags"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .createUser, .updateUser:
            return .post
        default:
            return .get
        }
    }
    public var task: Task {
        switch self {

        case let .playlist_detail(id): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case let .playlist(limit,cat): // Always send parameters as JSON in request body
            var parameters : [String: Any] = ["limit": limit]
            if let c = cat,c.count > 0{
                parameters["cat"] = c
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .playlist_boutique(limit,cat): // Always send parameters as JSON in request body
            var parameters : [String: Any] = ["limit": limit]
            if let c = cat,c.count > 0{
                parameters["cat"] = c
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .new_mv(limit): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case let .exclusive_mv(limit): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case let .personalized(limit): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case let .music_url(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case let .mv_url(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case let .simi_mv(mvid):
            return .requestParameters(parameters: ["mvid": mvid], encoding: URLEncoding.queryString)
        case let .banner(type):
            return .requestParameters(parameters: ["type": type], encoding: URLEncoding.queryString)
        case let .ranklist(idx):
            return .requestParameters(parameters: ["idx": idx], encoding: URLEncoding.queryString)
        case let .comment_mv(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
            
        case let .updateUser(_, firstName, lastName):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.queryString)
        case let .createUser(firstName, lastName): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        case let .calendar(startTime: startTime, endTime: endTime):
            return .requestParameters(parameters: ["startTime": startTime, "endTime": endTime], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    public var sampleData: Data {
        switch self {
            
        case .zen, .personal_fm, .personalized,.personal_mv,.playlist_detail,.music_url,.mv_url:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .showUser(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
        case .createUser(let firstName, let lastName):
            return "{\"id\": 100, \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .updateUser(let id, let firstName, let lastName):
            return "{\"id\": \(id), \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .showAccounts:
            // Provided you have a file named accounts.json in your bundle.
            guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            
        default:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
