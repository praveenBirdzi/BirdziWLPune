/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol CircleTransitionable {
  var triggerButton: UIButton { get }
  var contentTextView: UITextView { get }
  var mainView: UIView { get }
}

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
  weak var context: UIViewControllerContextTransitioning?

  //make this zero for now and see if it matters when it comes time to make it interactive
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.0
  }
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) as? CircleTransitionable,
      let toVC = transitionContext.viewController(forKey: .to) as? CircleTransitionable,
      let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
        transitionContext.completeTransition(false)
        return
    }
    
    context = transitionContext

    let containerView = transitionContext.containerView
    
    //Background View With Correct Color
    let backgroundView = UIView()
    backgroundView.frame = toVC.mainView.frame
    backgroundView.backgroundColor = fromVC.mainView.backgroundColor
    containerView.addSubview(backgroundView)
    
    //Animate old view offscreen
    containerView.addSubview(snapshot)
    fromVC.mainView.removeFromSuperview()
    animateOldTextOffscreen(fromView: snapshot)
    
    //Growing Circular Mask
    containerView.addSubview(toVC.mainView)
    animate(toView: toVC.mainView, fromTriggerButton: fromVC.triggerButton)
    
    //Animate Text in with a Fade
    animateToTextView(toTextView: toVC.contentTextView, fromTriggerButton: fromVC.triggerButton)
  }
  
  func animateOldTextOffscreen(fromView: UIView) {
    UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
      fromView.center = CGPoint(x: fromView.center.x - 1000, y: fromView.center.y + 1500)
      fromView.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
    }, completion: nil)
  }
  func animate(toView: UIView, fromTriggerButton triggerButton: UIButton) {
    //Starting Path
    let rect = CGRect(x: triggerButton.frame.origin.x,
                      y: triggerButton.frame.origin.y,
                      width: triggerButton.frame.width,
                      height: triggerButton.frame.width)
    let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
    
    //Destination Path
    let fullHeight = toView.bounds.height
    let extremePoint = CGPoint(x: triggerButton.center.x,
                               y: triggerButton.center.y - fullHeight)
    let radius = sqrt((extremePoint.x*extremePoint.x) +
      (extremePoint.y*extremePoint.y))
    let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: -radius,
                                                                               dy: -radius))
    
    //Actual mask layer
    let maskLayer = CAShapeLayer()
    maskLayer.path = circleMaskPathFinal.cgPath
    toView.layer.mask = maskLayer
    
    //Mask Animation
    let maskLayerAnimation = CABasicAnimation(keyPath: "path")
    maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
    maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
    maskLayerAnimation.delegate = self
    maskLayer.add(maskLayerAnimation, forKey: "path")
  }
  
  func animateToTextView(toTextView: UIView, fromTriggerButton: UIButton) {
    //Start toView offscreen a little and animate it to normal
    let originalCenter = toTextView.center
    toTextView.alpha = 0.0
    toTextView.center = fromTriggerButton.center
    toTextView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    
    UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
      toTextView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      toTextView.center = originalCenter
      toTextView.alpha = 1.0
    }, completion: nil)
  }
}

extension CircularTransition: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    context?.completeTransition(true)
  }
}
