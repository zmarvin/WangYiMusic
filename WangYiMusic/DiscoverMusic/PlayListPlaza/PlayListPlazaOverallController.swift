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

class PlayListPlazaOverallController: UIViewController,GXSegmentTitleViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PlayListPlazaTopCarouselViewScrollCenterCellObserver {
    let disposeBag = DisposeBag()
    
    let segmentView = GXSegmentTitleView()
    let pageViewController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    let allCategoryBtn = UIButton()
    let backEffectView = UIImageView()
    var headerUpPartNavBackgroundImage : UIImage?
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
                let recommendController = PlayListPlazaContentRecommendController()
                recommendController.topCarouselViewScrollCenterCellObserver = self
                return recommendController
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
        self.edgesForExtendedLayout = [.left,.right,.bottom]
        let items: [String] = inPlazaCategoryModels.map{$0.name}
        let config = GXSegmentTitleView.Configuration()
        config.positionStyle = .bottom
        config.titleMargin = 18.5
        config.indicatorStyle = .dynamic
        config.indicatorFixedWidth = 30.0
        config.indicatorFixedHeight = 5.0
        config.indicatorAdditionWidthMargin = 5.0
        config.indicatorAdditionHeightMargin = 2.0
        config.isShowSeparator = false
        config.isShowBottomLine = false

        segmentView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 60)
        segmentView.setupSegmentTitleView(config: config, titles: items)
        segmentView.delegate = self
        self.view.addSubview(segmentView)
        segmentView.backgroundColor = .white
        
        allCategoryBtn.setImage(UIImage(named: "em_playlist_allcategory"), for: UIControl.State.normal)
        allCategoryBtn.imageView?.contentMode = .scaleAspectFit
        allCategoryBtn.backgroundColor = .white
        self.view.insertSubview(allCategoryBtn, aboveSubview: segmentView)
        let allCategoryBtnHight = segmentView.frame.height
        let allCategoryBtnY : CGFloat = 0
        let allCategoryBtnWidth : CGFloat = 80
        allCategoryBtn.frame = CGRect(x: segmentView.frame.maxX-allCategoryBtnWidth, y: allCategoryBtnY, width: allCategoryBtnWidth, height: allCategoryBtnHight)
        
        let allCategoryBtnGradientLayer = CAGradientLayer()
        allCategoryBtnGradientLayer.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor(white: 1, alpha: 0.5).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
        ]
        allCategoryBtnGradientLayer.locations = [0,0.25,0.5,1];
        allCategoryBtnGradientLayer.startPoint = CGPoint(x: 0, y: 0);
        allCategoryBtnGradientLayer.endPoint = CGPoint(x: 1, y: 0);
        allCategoryBtnGradientLayer.frame = CGRect(x: 0, y: 0, width: self.allCategoryBtn.bounds.width, height: self.allCategoryBtn.bounds.height)
        self.allCategoryBtn.layer.mask = allCategoryBtnGradientLayer
        self.allCategoryBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        pageViewController.edgesForExtendedLayout = UIRectEdge.left
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, belowSubview: segmentView)
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.segmentView.frame.height - 10) // 10是增加颜色特效的范围高度
        }
        
//        backEffectView.frame = CGRect(x: 0, y: 0, width: WY_SCREEN_WIDTH, height: 100)
//        self.view.insertSubview(backEffectView, at: 0)
    }
    
    func setUpState() {
        allCategoryBtn.rx.tap.subscribe(onNext: {[unowned self] in
            // MARK: push 所有分类控制器
            let vc = PlayListPlazaOverallCategoryController()
            vc.inPlazaCategoryModels = self.inPlazaCategoryModels
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        self.segmentTitleView(segmentView, at: 0)
        
        PlayListPlazaContentBaseController.renderObservable.subscribe(onNext: { [unowned self] image in
            let upExpectHeight = WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
            let downExpectHeight : CGFloat = self.segmentView.frame.height
            let expectHeight = upExpectHeight + downExpectHeight
            let expectWidth = WY_SCREEN_WIDTH
            
            let shrinkWidth : CGFloat = 10
            let shrinkHeight = shrinkWidth * expectHeight/expectWidth
            let shrinkImage = image.reSize(newSize: CGSize(width: shrinkWidth, height: shrinkHeight), scale: 1)
            let expectNoBlurImage = shrinkImage?.reSize(newSize: CGSize(width: expectWidth, height: expectHeight), scale: 1)
            let blurNumber : CGFloat = 25
            let expectNoGradientImage = UIImage.boxBlurImage( expectNoBlurImage, withBlurNumber: blurNumber)
            // 添加渐变
            let cgColor1 = UIColor(white: 1, alpha: 0.5).cgColor
            let cgColor2 = UIColor(white: 1, alpha: 0.7).cgColor
            let cgColor3 = UIColor(white: 1, alpha: 1).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: expectNoGradientImage.size.width, height: expectNoGradientImage.size.height)
            gradientLayer.locations = [0,0.6,1];
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [cgColor1,cgColor2,cgColor3]
            UIGraphicsBeginImageContext(expectNoGradientImage.size)
            expectNoGradientImage.draw(in: CGRect(x: 0, y: 0, width: expectNoGradientImage.size.width, height: expectNoGradientImage.size.height))
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let wrapExpectImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let expectImage = wrapExpectImage else { return }
            
            let upExpectImage = expectImage.cut(rect: CGRect(x: 0, y: 0, width: expectWidth, height: upExpectHeight))?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: UIImage.ResizingMode.stretch)
            let downExpectImage = expectImage.cut(rect: CGRect(x: 0, y: upExpectHeight, width: expectWidth, height: downExpectHeight))
            
            self.navigationController?.navigationBar.setBackgroundImage(upExpectImage, for: UIBarMetrics.default)
            self.segmentView.image = downExpectImage
            self.headerUpPartNavBackgroundImage = upExpectImage
            
            let wrapAllCategoryBtnImage = downExpectImage?.cut(rect: self.allCategoryBtn.frame)
            self.allCategoryBtn.setBackgroundImage(wrapAllCategoryBtnImage, for: UIControl.State.normal)
            self.allCategoryBtn.setBackgroundImage(wrapAllCategoryBtnImage, for: UIControl.State.highlighted)
        }).disposed(by: disposeBag)
    }
    
    func setUpGesture() {// 解决uiscrollview和系统的返手势冲突
        if let scrollView = self.pageViewController.view.subviews.first as? UIScrollView , let gesture = self.navigationController?.interactivePopGestureRecognizer{
            scrollView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(self.headerUpPartNavBackgroundImage, for: UIBarMetrics.default)
    }
    
    // MARK: -- PlayListPlazaTopCarouselViewScrollCenterCellObserver
    func playListPlazaContentRecommendControllerTopCarouselViewScrollCenter(cell:PlayListPlazaCarouselCell,model:PlayListPlazaModel,indexPath:IndexPath){
        self.toRenderImage(with: model)
    }
    
    func pageViewControllerCurrentShowedViewController(viewController:PlayListPlazaContentBaseController) {
        var model : PlayListPlazaModel?
        if let vc = viewController as? PlayListPlazaContentRecommendController{
            model = vc.topCarouselCenterCellModel
        }else{
            model = viewController.firstModel
            if model == nil {
                viewController.rx.observe(\.firstModel).filter{$0 != nil}.take(1).subscribe(onNext: { [unowned self] model in
                    self.toRenderImage(with: model)
                }).disposed(by: disposeBag)
            }
        }
        self.toRenderImage(with: model)
    }
    
    func toRenderImage(with model:PlayListPlazaModel?) {
        guard let unwrapModel = model else { return }
        guard let url = URL(string: unwrapModel.coverImgUrl) else { return }
        PlayListPlazaContentBaseController.toRenderImageKeySubject.onNext(url)
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
        guard let baseController = vc as? PlayListPlazaContentBaseController else { return }
        self.pageViewControllerCurrentShowedViewController(viewController: baseController)
    }
    // MARK: -- GXSegmentTitleViewDelegate
    func segmentTitleView(_ page: GXSegmentTitleView, at index: Int){
        let direction = index > (self.subViewControllers.count-1) ? UIPageViewController.NavigationDirection.forward : UIPageViewController.NavigationDirection.reverse
        if index >= self.subViewControllers.count {
            return
        }
        let selectedVC = self.subViewControllers[index]
        guard let baseController = selectedVC as? PlayListPlazaContentBaseController else { return }
        self.pageViewController.setViewControllers([selectedVC],direction: direction,animated: false) {[unowned self] (isCompletion) in
            self.pageViewControllerCurrentShowedViewController(viewController: baseController)
        }
    }

    deinit {
        print("PlayListPlazaOverallController 销毁了")
    }
}
