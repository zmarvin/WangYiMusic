//
//  EMBaseAPI+Rx.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
 
import SwiftyJSON

class EMBaseRxAPI {
    let provider = MoyaProvider<MyService>()
    func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
        return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
    }
}
