//
//  MusicPlayTransitionManage.swift
//  EnjoyMusic
//
//  Created by mac on 2021/1/12.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation

let musicPlayControllerTransitionAnimateDuration : TimeInterval = 1
class MusicPlayControllerDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return musicPlayControllerTransitionAnimateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        containerView.addSubview(fromView)
        
        if let vc = fromVC as? MusicPlayController,let currentCell = vc.discCollectionView.currentCell {
            guard let keyWindow = UIApplication.shared.keyWindow else {return}
            let shrinkControlView = MusicPlayShrinkControllPannelView.shared

            let tempDiscImageView = UIImageView(image: shrinkControlView.discImageView.screenShot_10Scale())
            let discBigWindowFrame = currentCell.convert(currentCell.discImageView.frame, to: keyWindow)
            tempDiscImageView.frame = discBigWindowFrame
            let currentCellTransform = currentCell.discImageView.layer.presentation()!.affineTransform()
            tempDiscImageView.transform = currentCellTransform
            keyWindow.addSubview(tempDiscImageView)
            vc.discCollectionView.isHidden = true
            vc.circularTransparenceLayer.isHidden = true
            vc.needleImageView.isHidden = true

            let maskView = UIView(frame: vc.view.bounds)
            maskView.backgroundColor = .white
            maskView.alpha = 0
            vc.view.addSubview(maskView)

            let fromValue = currentCell.discImageView.layer.presentation()?.value(forKeyPath: "transform.rotation.z") as! CGFloat
            shrinkControlView.discImageView.isHidden = true
            let discSmallWindowframe = shrinkControlView.convert(shrinkControlView.discImageView.frame, to: keyWindow)

            UIView.animate(withDuration: musicPlayControllerTransitionAnimateDuration, animations: {
                tempDiscImageView.bounds = CGRect(x: 0, y: 0, width: discSmallWindowframe.width, height: discSmallWindowframe.height)
                tempDiscImageView.center = CGPoint(x: discSmallWindowframe.midX, y: discSmallWindowframe.midY)
                maskView.alpha = 1
                fromView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            }, completion: { isCompletion in
                let isCancel = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!isCancel)
                //  MARK: animationDidStart 解决衔接时，偶有抖闪的问题
                if isCancel {
                    currentCell.reSetUpAnimation(fromValue: fromValue, animationDidStart: {
                        refreshState()
                    })
                }else{
                    shrinkControlView.reSetUpAnimation(fromValue: fromValue, animationDidStart: {
                        refreshState()
                    })
                    print("forDismissed动画完成")
                }
            })
            // MARK: 1，防止completion有时不调用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+musicPlayControllerTransitionAnimateDuration+1) {
//                _ = tempDiscImageView
            }
            func refreshState(){
                shrinkControlView.discImageView.isHidden = false
                tempDiscImageView.removeFromSuperview()
                vc.discCollectionView.isHidden = false
                vc.circularTransparenceLayer.isHidden = false
                vc.needleImageView.isHidden = false
            }
        }
    }
}

class MusicPlayControllerPresentedAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return musicPlayControllerTransitionAnimateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        var tempFrame = transitionContext.finalFrame(for: toVC)
        tempFrame.origin.y = tempFrame.size.height
        toVC.view.frame = tempFrame
        containerView.addSubview(toView)
        
        guard let vc = toVC as? MusicPlayController else {return}
        let shrinkControlView = MusicPlayShrinkControllPannelView.shared
        let maskView = UIView()
        maskView.frame = vc.view.bounds
        maskView.backgroundColor = .white
        maskView.alpha = 1
        vc.view.addSubview(maskView)
        
        if !shrinkControlView.isShow {
            
            UIView.animate(withDuration: musicPlayControllerTransitionAnimateDuration, animations: {
                maskView.alpha = 0
                vc.view.frame = transitionContext.finalFrame(for: toVC)
            }, completion: { isCompletion in
                maskView.removeFromSuperview()
                transitionContext.completeTransition(true)
                MusicPlayShrinkControllPannelView.show(belowSubview: containerView)
            })
            return
        }
        let tempDiscImageView = UIImageView(image: shrinkControlView.discImageView.screenShot_10Scale())
        let discSmollWindowFrame = shrinkControlView.convert(shrinkControlView.discImageView.frame, to: containerView)
        tempDiscImageView.frame = discSmollWindowFrame
        tempDiscImageView.transform = shrinkControlView.discImageView.layer.presentation()!.affineTransform()
        containerView.addSubview(tempDiscImageView)
        tempDiscImageView.snp.removeConstraints()

        let discBigWindowframeW = MusicPlayDiscToScreenW_Ratio * WY_SCREEN_WIDTH
        let discBigWindowframeCenterY = (WY_SCREEN_HEIGHT - vc.bottomControlViewHeight - WY_NAV_BAR_HEIGHT - WY_STATUS_BAR_HEIGHT)/2 + WY_NAV_BAR_HEIGHT + WY_STATUS_BAR_HEIGHT
        let discBigWindowBounds = CGRect(x: 0, y: 0, width: discBigWindowframeW, height: discBigWindowframeW)
        let discBigWindowCenter = CGPoint(x: WY_SCREEN_WIDTH/2 , y: discBigWindowframeCenterY)
        
        vc.discCollectionView.isHidden = true
        vc.needleImageView.isHidden = true
        vc.circularTransparenceLayer.isHidden = true
        shrinkControlView.discImageView.isHidden = true
        let fromValue = shrinkControlView.discImageView.layer.presentation()?.value(forKeyPath: "transform.rotation.z") as! CGFloat
        UIView.animate(withDuration: musicPlayControllerTransitionAnimateDuration, animations: {
            maskView.alpha = 0
            tempDiscImageView.bounds = discBigWindowBounds
            tempDiscImageView.center = discBigWindowCenter
            vc.view.frame = transitionContext.finalFrame(for: toVC)
            
        }, completion: { isCompletion in
            
            maskView.removeFromSuperview()
            print("Presented动画完成")
            transitionContext.completeTransition(true)
            //  MARK: animationDidStart 解决衔接时，偶有抖闪的问题
            vc.discCollectionView.currentCell?.reSetUpAnimation(fromValue: fromValue, animationDidStart: { [weak vc] in
                vc?.discCollectionView.isHidden = false
                tempDiscImageView.removeFromSuperview()
            })
            vc.circularTransparenceLayer.isHidden = false
            vc.needleImageView.isHidden = false
            shrinkControlView.discImageView.isHidden = false
        })
        // MARK: 1，防止completion不调用，2，防止暂停状态animationDidStart没有调用，3，多0.2秒,解决衔接时，偶有抖闪的问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + musicPlayControllerTransitionAnimateDuration + 0.2) {
            vc.discCollectionView.isHidden = false
            tempDiscImageView.removeFromSuperview()
        }
        
    }

}

class MusicPlayTransitionManage: NSObject ,UIViewControllerTransitioningDelegate{

    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MusicPlayControllerPresentedAnimatedTransitioning()
    }
    
    // 截图动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MusicPlayControllerDismissAnimatedTransitioning()
    }
    
    /* view动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let vc = dismissed as? MusicPlayController,let currentCell = vc.discCollectionView.currentCell {
            guard let keyWindow = UIApplication.shared.keyWindow else {return nil}
            let shrinkControlView = MusicPlayShrinkControllPannelView.shared
            
            let tempDiscImageView = currentCell.discImageView
            let discBigWindowFrame = currentCell.convert(tempDiscImageView.frame, to: keyWindow)
            tempDiscImageView.frame = discBigWindowFrame
            tempDiscImageView.removeFromSuperview()
            keyWindow.addSubview(tempDiscImageView)
            tempDiscImageView.snp.removeConstraints()
            vc.circularTransparenceLayer.isHidden = true
            vc.discCollectionView.isHidden = true
            vc.needleImageView.isHidden = true
            let discSmallWindowframe = shrinkControlView.convert(shrinkControlView.discImageView.frame, to: keyWindow)
            
            let maskView = UIView()
            maskView.frame = vc.view.bounds
            maskView.backgroundColor = .white
            maskView.alpha = 0
            vc.view.addSubview(maskView)
            
            currentCell.resumeAnimation()
            currentCell.picView.layer.removeAllAnimations()
            shrinkControlView.isHidden = true
            UIView.animate(withDuration: 1, animations: {
                tempDiscImageView.frame = discSmallWindowframe
                maskView.alpha = 1
                tempDiscImageView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(discSmallWindowframe.minX)
                    make.top.equalToSuperview().offset(discSmallWindowframe.minY)
                    make.width.height.equalTo(discSmallWindowframe.size.width)
                }
                currentCell.picView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                }
                currentCell.picView.layer.cornerRadius = shrinkControlView.picView.layer.cornerRadius
                keyWindow.layoutIfNeeded()
            }, completion: { isCompletion in
//                let discShrinkControlframe = keyWindow.convert(discSmallWindowframe, to: shrinkControlView)
//                tempDiscImageView.frame = discShrinkControlframe
                tempDiscImageView.removeFromSuperview()
                shrinkControlView.isHidden = false
                print("forDismissed动画完成")
//                shrinkControlView.addSubview(tempDiscImageView)
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                tempDiscImageView.removeFromSuperview()
            }
        }
        return DismissAnimatedTransitioning()
    }
    */
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let tran = dismissalInteraction.isInteraction ? dismissalInteraction : nil
        return tran
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    var dismissalInteraction = MusicPlayForDismissalInteraction()
}

class MusicPlayForDismissalInteraction: UIPercentDrivenInteractiveTransition {
    var isInteraction = false
    var interactiveGesture = UIPanGestureRecognizer()
    override init() {
        super.init()
        interactiveGesture.addTarget(self, action: #selector(interactiveGestureAction))
    }
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }
    @objc func interactiveGestureAction(pan:UIPanGestureRecognizer){
        
        guard let panView = pan.view else { return }
        let point = pan.translation(in: panView)
        let offset = max(point.x * 1.5, point.y)
        let progress = offset/WY_SCREEN_HEIGHT
        switch pan.state {
        case .began:
            self.isInteraction = true
            if let responder = pan.view?.next, let vc = responder as? MusicPlayController{
                vc.dismiss(animated: true, completion: nil)
            }
            break
        case .changed:
            self.update(progress)
        case .ended:
            if progress >= 0.5{
                self.finish()
            }else{
                self.cancel()
            }
        default:
            self.cancel()
        }
    }
}
