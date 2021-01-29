//
//  EMBaseNavigationController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/4.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

extension UIViewController{
    
    enum Nav_BackBarButtonColor {
        case black
        case white
        case custom
    }

    struct Nav_AssociatedObjectKeys {
        static var backBarButtonColorKey = "backBarButtonColorKey"
    }
    
    var nav_BackBarButtonColor : Nav_BackBarButtonColor {
        get{
            if let color = objc_getAssociatedObject(self, &Nav_AssociatedObjectKeys.backBarButtonColorKey) as? Nav_BackBarButtonColor {
                return color
            }
            return .black
        }
        set{
            objc_setAssociatedObject(self, &Nav_AssociatedObjectKeys.backBarButtonColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

class EMBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    var hidesBottomBarWhenPushedViewController = [UIViewController]()
    var isHideTabBar : Bool {
        guard self.hidesBottomBarWhenPushedViewController.count > 0 else { return false }
        guard let hidesBottomBarVC = self.hidesBottomBarWhenPushedViewController.first else { return false }
        guard let index = self.children.firstIndex(of: hidesBottomBarVC) else { return false }
        guard let topVc = self.topViewController else { return false }
        guard let topVCIndex = self.children.firstIndex(of: topVc) else { return false }
        return topVCIndex >= index
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.children.count > 1
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewController.hidesBottomBarWhenPushed {
            viewController.hidesBottomBarWhenPushed = false
            hidesBottomBarWhenPushedViewController.append(viewController)
            hideTabbar()
        }
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.setUpBackBarButtonColorWith(viewController: viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        guard let vc = super.popViewController(animated: animated) else {return nil}
        if hidesBottomBarWhenPushedViewController.contains(vc) {
            hidesBottomBarWhenPushedViewController.removeAll { $0 === vc }
            showTabbar()
        }
        return vc
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let vcs = super.popToRootViewController(animated: animated) else { return nil }
        guard let fisrt = vcs.first else { return vcs }
        if hidesBottomBarWhenPushedViewController.contains(fisrt) {
            hidesBottomBarWhenPushedViewController.removeAll()
            showTabbar()
        }
        return vcs
    }
    
    func showTabbar() {
        guard let tabbar = self.tabBarController?.tabBar else{return}
        var tempFrame = tabbar.frame
        tempFrame.origin.y = tempFrame.origin.y - WY_TAB_BAR_HEIGHT - WY_SAFE_BOTTOM_MARGIN
        UIView.animate(withDuration: 0.3) {
            tabbar.frame = tempFrame
        }
    }
    
    func hideTabbar() {
        guard let tabbar = self.tabBarController?.tabBar else{return}
        var tempFrame = tabbar.frame
        tempFrame.origin.y = tempFrame.origin.y + WY_TAB_BAR_HEIGHT + WY_SAFE_BOTTOM_MARGIN
        UIView.animate(withDuration: 0.3) {
            tabbar.frame = tempFrame
        }
    }
    
    func setUpBackBarButtonColorWith(viewController: UIViewController) {
        if self.children.count == 0 {
            viewController.nav_BackBarButtonColor = .custom
        }
        switch viewController.nav_BackBarButtonColor {
        case .black:
            let backBarBtn = UIButton()
            backBarBtn.setImage(UIImage(named: "nav_back_arrow_black"), for: .normal)
            backBarBtn.addTarget(self, action: #selector(backBarBtnClick), for: .touchUpInside)
            let backBarButtonItem = UIBarButtonItem(customView: backBarBtn)
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        case .white:
            let backBarBtn = UIButton()
            backBarBtn.setImage(UIImage(named: "nav_back_arrow_white"), for: .normal)
            backBarBtn.addTarget(self, action: #selector(backBarBtnClick), for: .touchUpInside)
            let backBarButtonItem = UIBarButtonItem(customView: backBarBtn)
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        case .custom:
            break
        }
    }
    
    @objc func backBarBtnClick(){
        _ = self.popViewController(animated: true)
    }

    override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}

