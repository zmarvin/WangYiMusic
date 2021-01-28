//
//  EnjoyMusicHeaderPrefix.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/2.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import UIKit

let WY_SCREEN_BOUNDS = UIScreen.main.bounds
let WY_SCREEN_WIDTH = UIScreen.main.bounds.width
let WY_SCREEN_HEIGHT = UIScreen.main.bounds.height

let WY_IS_IPHONEX = isIPhoneX()
///导航栏高度
let WY_NAV_BAR_HEIGHT:CGFloat = 44.0
///状态栏高度
let WY_STATUS_BAR_HEIGHT:CGFloat = getStatusBarHight()
///状态栏和导航栏总高度
let WY_NAV_BAR_AND_STATUS_BAR_HEIGHT:CGFloat = WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
///底部安全距离
let WY_SAFE_BOTTOM_MARGIN:CGFloat = getSafeBottomMargin()
let WY_TAB_BAR_HEIGHT:CGFloat = 49

let WY_M_PI = CGFloat(Double.pi)

private func isIPhoneX() -> Bool{
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}
private func getStatusBarHight() -> CGFloat {
    var statusBarHeight:CGFloat = 0
    if #available(iOS 13.0, *) {
        let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        statusBarHeight = statusBarManager?.statusBarFrame.size.height ?? 0
    }else{
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    }
    return statusBarHeight
}
private func getSafeBottomMargin() -> CGFloat {
    var safeBottom:CGFloat = 0
    if #available(iOS 11, *) {
        let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets
        safeBottom = safeArea?.bottom ?? 0
    }
    return safeBottom
}

let WY_PLACEHOLDER_IMAGE = UIImage(named: "em_icon_img_loading")
let WY_LIST_LOADING_IMAGES = (1...4).map {UIImage(named: "em_list_loading\($0)")!}

