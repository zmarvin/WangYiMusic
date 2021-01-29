//
//  PlayListPlazaOverallController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/1.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
class PlayListPlazaOverallController: UIViewController,GXSegmentTitleViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let disposeBag = DisposeBag()
    
    let segmentView = GXSegmentTitleView()
    let pageViewController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    let allCategoryBtn = UIButton()
    
    lazy var inPlazaCategoryModels: [PlayListPlazaCategoryModel] = {
        var categoryModels = [PlayListPlazaCategoryModel]()
        let model1 = PlayListPlazaCategoryModel()
        model1.name = "推荐"
        model1.category = "0"
        categoryModels.append(model1)
        let model2 = PlayListPlazaCategoryModel()
        model2.name = "官方"
        model2.category = "0"
        categoryModels.append(model2)
        let model3 = PlayListPlazaCategoryModel()
        model3.name = "视频歌单"
        model3.category = "0"
        categoryModels.append(model3)
        let model4 = PlayListPlazaCategoryModel()
        model4.name = "精品"
        model4.category = "0"
        categoryModels.append(model4)
        let model5 = PlayListPlazaCategoryModel()
        model5.name = "欧美"
        model5.category = "0"
        categoryModels.append(model5)
        let model6 = PlayListPlazaCategoryModel()
        model6.name = "轻音乐"
        model6.category = "0"
        model6.hot = true
        categoryModels.append(model6)
        let model7 = PlayListPlazaCategoryModel()
        model7.name = "摇滚"
        model7.category = "0"
        model7.hot = true
        categoryModels.append(model7)
        let model8 = PlayListPlazaCategoryModel()
        model8.name = "民谣"
        model8.category = "0"
        model8.hot = true
        categoryModels.append(model8)
        let model9 = PlayListPlazaCategoryModel()
        model9.name = "电子"
        model9.category = "0"
        model9.hot = true
        categoryModels.append(model9)
        return categoryModels
    }()
    
    lazy var subViewControllers : [UIViewController] = {
        return inPlazaCategoryModels.map { categoryModel in
            if categoryModel.name == "推荐" {
                return PlayListPlazaContentRecommendController()
            }
            if categoryModel.name == "精品" {
                return PlayListPlazaContentBoutiqueController()
            }
            return PlayListPlazaContentCommonController(categoryModel:categoryModel)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpState()
        self.setUpGesture()
    }
    
    func setUpView() {
        self.navigationItem.title = "歌单广场"
        
        let items: [String] = inPlazaCategoryModels.map{$0.name}
        let config = GXSegmentTitleView.Configuration()
        config.positionStyle = .bottom
        config.indicatorStyle = .dynamic
        config.indicatorFixedWidth = 30.0
        config.indicatorFixedHeight = 5.0
        config.indicatorAdditionWidthMargin = 5.0
        config.indicatorAdditionHeightMargin = 2.0
        config.isShowSeparator = false
        config.isShowBottomLine = false
        let allCategoryBtnWidth : CGFloat = 70
        let overlapW : CGFloat = 30
        segmentView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH - (allCategoryBtnWidth-overlapW), height: 50)
        segmentView.setupSegmentTitleView(config: config, titles: items)
        segmentView.delegate = self
        self.view.addSubview(segmentView)
        segmentView.backgroundColor = .white
        
        allCategoryBtn.setImage(UIImage(named: "em_playlist_allcategory"), for: UIControl.State.normal)
        allCategoryBtn.imageView?.contentMode = .scaleAspectFit
        self.view.insertSubview(allCategoryBtn, aboveSubview: segmentView)
        let allCategoryBtnHight = segmentView.frame.height * 0.5
        let allCategoryBtnY = (segmentView.frame.height - allCategoryBtnHight)/2
        allCategoryBtn.frame = CGRect(x: segmentView.frame.maxX-overlapW, y: allCategoryBtnY, width: allCategoryBtnWidth+10, height: allCategoryBtnHight)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
        ]
        gradientLayer.locations = [0,1];
        gradientLayer.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer.endPoint = CGPoint(x: 1, y: 0);
        gradientLayer.frame = CGRect(x: 0, y: 0, width: allCategoryBtn.bounds.width * 0.4, height: allCategoryBtn.bounds.height)
        allCategoryBtn.layer.addSublayer(gradientLayer)
        
        pageViewController.edgesForExtendedLayout = UIRectEdge.left
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }
    
    func setUpState() {
        allCategoryBtn.rx.tap.subscribe(onNext: {[unowned self] in
            // MARK: push 所有分类控制器
            let vc = PlayListPlazaOverallCategoryController()
            vc.inPlazaCategoryModels = self.inPlazaCategoryModels
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        self.segmentTitleView(segmentView, at: 0)
    }
    
    func setUpGesture() {// 解决uiscrollview和系统的返手势冲突
        if let scrollView = self.pageViewController.view.subviews.first as? UIScrollView , let gesture = self.navigationController?.interactivePopGestureRecognizer{
            scrollView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    // MARK: -- UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        guard let index = self.subViewControllers.firstIndex(of: viewController ) else { return nil }
        if index == 0 {
            return nil
        }
        return self.subViewControllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.subViewControllers.firstIndex(of: viewController) else { return nil }
        if index+1 >= self.subViewControllers.count{
            return nil
        }
        return self.subViewControllers[index+1]
    }
    // MARK: -- UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        guard let vc = pageViewController.viewControllers?.last else { return }
        guard let index = self.subViewControllers.firstIndex(of: vc) else { return }
        self.segmentView.setSelectIndex(at: index, animated: true)
    }
    // MARK: -- GXSegmentTitleViewDelegate
    func segmentTitleView(_ page: GXSegmentTitleView, at index: Int){
        let direction = index > (self.subViewControllers.count-1) ? UIPageViewController.NavigationDirection.forward : UIPageViewController.NavigationDirection.reverse
        if index >= self.subViewControllers.count {
            return
        }
        let selectedVC = self.subViewControllers[index]
        self.pageViewController.setViewControllers([selectedVC],direction: direction,animated: false,completion: nil)
    }
    
    deinit {
        print("PlayListPlazaOverallController 销毁了")
    }
}
