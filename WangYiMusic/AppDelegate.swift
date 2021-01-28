//
//  AppDelegate.swift
//  WangYiMusic
//
//  Created by mac on 2021/1/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let c1 = DiscoverMusicController(style: UITableView.Style.plain)
        let navC1 = EMBaseNavigationController(rootViewController: c1)
        navC1.view.backgroundColor = UIColor.white
        navC1.navigationBar.isTranslucent = false
        navC1.navigationBar.shadowImage = UIImage()
        navC1.tabBarItem.title = "发现"
        navC1.tabBarItem.image = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_discovery")
        navC1.tabBarItem.selectedImage = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_discovery_prs")
        
        let c2 = UIViewController()
        let navC2 = EMBaseNavigationController(rootViewController: c2)
        navC2.view.backgroundColor = UIColor.white
        navC2.tabBarItem.title = "视频"
        navC2.tabBarItem.image = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_video_new")
        navC2.tabBarItem.selectedImage = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_video_new_prs")
        
        let c3 = UIViewController()
        let navC3 = EMBaseNavigationController(rootViewController: c3)
        navC3.view.backgroundColor = UIColor.white
        navC3.tabBarItem.title = "我的"
        navC3.tabBarItem.image = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_music_new")
        navC3.tabBarItem.selectedImage = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_music_new_prs")
        
        let c4 = UIViewController()
        let navC4 = EMBaseNavigationController(rootViewController: c4)
        navC4.view.backgroundColor = UIColor.white
        navC4.tabBarItem.title = "朋友"
        navC4.tabBarItem.image = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_friend")
        navC4.tabBarItem.selectedImage = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_friend_prs")
        
        let c5 = UIViewController()
        let navC5 = EMBaseNavigationController(rootViewController: c5)
        navC5.view.backgroundColor = UIColor.white
        navC5.tabBarItem.title = "账号"
        navC5.tabBarItem.image = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_account")
        navC5.tabBarItem.selectedImage = UIImage(named: "EMTabbarIcon.bundle/cm4_btm_icn_account_prs")
        
        let tabBarC = UITabBarController()
        tabBarC.viewControllers = [navC1,navC2,navC3,navC4,navC5]
        UITabBar.appearance().tintColor = .red
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarC
        self.window?.makeKeyAndVisible()
        
        if MusicPlayManager.shared.unArchiveFromdisk() {
            MusicPlayShrinkControllPannelView.show()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        MusicPlayManager.shared.archiveTodisk()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

