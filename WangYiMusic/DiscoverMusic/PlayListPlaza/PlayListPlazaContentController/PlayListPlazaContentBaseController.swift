//
//  PlayListPlazaContentBaseController.swift
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/2/3.
//

import Foundation
import RxSwift
import Kingfisher

class PlayListPlazaContentBaseController: UIViewController {
    
    let disposeBag = DisposeBag()
    var API = RxPlayListPlazaAPI()
    var dataModels : [PlayListPlazaModel]?{
        didSet{
            guard let model = dataModels?.first else { return }
            firstModel = model
        }
    }
    @objc dynamic var firstModel : PlayListPlazaModel?
    static var downloadedReadyRenderImageKeys = [URL]()
    static let downloadedReadyRenderImageKeysSubject = PublishSubject<[URL]>()
    static let toRenderImageKeySubject = PublishSubject<URL>()
    
    static var renderObservable = Observable.combineLatest(downloadedReadyRenderImageKeysSubject, toRenderImageKeySubject).filter { (downloadedReadyRenderImageKeys, toRenderImageKey) -> Bool in
        let isCon = downloadedReadyRenderImageKeys.contains(where: {$0 == toRenderImageKey})
        return isCon
    }.flatMap { (urls,url) -> Observable<UIImage> in
        return Observable<UIImage>.create { (observer) in
            KingfisherManager.shared.retrieveImageCompletionHandlerOnMainQueue(with: url) { (image, error, cacheType, url) in
                guard let image = image else {return}
                observer.onNext(image)
            }
            return Disposables.create()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PlayListPlazaContentBaseController销毁了")
    }
}
