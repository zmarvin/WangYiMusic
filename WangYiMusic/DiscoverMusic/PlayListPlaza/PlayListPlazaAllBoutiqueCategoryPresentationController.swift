//
//  PlayListPlazaAllBoutiqueCategoryPresentationController.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/4.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

class PlayListPlazaAllBoutiqueCategoryPresentationController: UIPresentationController {
    
    lazy var dimmingMaskView: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear.withAlphaComponent(0)
        btn.addTarget(self, action: #selector(dimmingMaskViewClick), for: UIControl.Event.touchUpInside)
        if let containerView = self.containerView{
            btn.frame = containerView.bounds
        }

        if let presentedView = self.presentedView{
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(roundedRect: presentedView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
            shapeLayer.frame = presentedView.bounds
            presentedView.layer.mask = shapeLayer
        }
        return btn
    }()
    
    @objc func dimmingMaskViewClick(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }

    override var frameOfPresentedViewInContainerView: CGRect{
        let presentedViewHight : CGFloat = WY_SCREEN_HEIGHT*0.6
        return CGRect(x: 0, y: WY_SCREEN_HEIGHT - presentedViewHight, width: WY_SCREEN_WIDTH, height: presentedViewHight)
    }
    
    override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(dimmingMaskView, at: 0)
        dimmingMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingMaskView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.3) {
            self.dimmingMaskView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingMaskView.removeFromSuperview()
        }
    }
    
}
