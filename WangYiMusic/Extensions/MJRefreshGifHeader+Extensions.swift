//
//  MJRefreshGifHeader+Extensions.swift
//  WangYiMusic
//
//  Created by ZhangZhan on 2021/1/29.
//

import Foundation

extension MJRefreshGifHeader{
    
    convenience init(custom refreshingBlock:@escaping ()->Void) {
        self.init(refreshingBlock: refreshingBlock)
        self.setTitle("加载中...", for: MJRefreshState.idle)
        self.setTitle("加载中...", for: MJRefreshState.pulling)
        self.setTitle("加载中...", for: MJRefreshState.refreshing)
        self.setTitle("加载完成", for: MJRefreshState.noMoreData)
        self.setImages(WY_LIST_LOADING_IMAGES, for: MJRefreshState.refreshing)
        self.lastUpdatedTimeLabel?.isHidden = true
    }
    func refresh() -> Self {
        self.beginRefreshing()
        return self
    }
}
