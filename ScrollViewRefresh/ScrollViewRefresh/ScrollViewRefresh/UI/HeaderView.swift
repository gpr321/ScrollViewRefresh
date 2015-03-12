//
//  HeaderView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class HeaderView: BaseView {
    var headerImagePath = "ScrollViewResh.Bundle".stringByAppendingPathComponent("tableview_pull_refresh.png")
    private let HEADER_HEIGHT:CGFloat = 44
    // 该值用来限制图标箭头的极限位置
    var tigerValue: CGFloat = -60
    var maxAngel: CGFloat = CGFloat(M_PI - 0.01)
    var isRotate: Bool = false
    // 记录当前顶部内边距
    var headerTopInset: CGFloat = 0
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        headerTopInset = BaseView.orginalInset.top
        setUpHeaderViewSize()
    }
    
    func setUpHeaderViewSize() {
        let headerW = scrollView!.bounds.size.width
        let headerX: CGFloat = 0
        let headerY: CGFloat = -HEADER_HEIGHT
        self.frame = CGRectMake(headerX, headerY, headerW, HEADER_HEIGHT)
    }
    
    override func imagePath() -> String? {
        return headerImagePath
    }
    
    override func observerKeyPath() -> [String]? {
        return ["contentOffset"]
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        let contentOffset = (change["new"] as! NSValue).CGPointValue()
        // 修正误差
        var distance = contentOffset.y
        if contentOffset.y < tigerValue {
            distance = tigerValue
        }
        if contentOffset.y < CGRectGetMaxY(self.frame) {
            self.hidden = false
            adjustImageView(distance)
            if !scrollView!.dragging {
                beginHeaderRefreshing()
            }
        } else {
            self.hidden = true
        }
    }
    
    func beginHeaderRefreshing() {
        let headerShowing = scrollView!.contentOffset.y
        if headerShowing < tigerValue && !isLoading {
            headerStartRefresh()
        }
    }
    
    func headerStartRefresh() {
        if isLoading { return }
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.duration = animationDuration
        anim.repeatCount = MAXFLOAT
        imageView!.layer.addAnimation(anim, forKey: nil)
        imageView!.image = loadingImage!
        // 滚动到指定位置
        let y = -self.bounds.height
        let contentOffset = CGPointMake(self.frame.origin.x,  y)
        BaseView.orginalInset.top = -y
        scrollView!.contentInset = BaseView.orginalInset
        scrollView!.setContentOffset(contentOffset, animated: true)
        if block != nil {
            block!()
        }
        isLoading = true
    }
    
    func endHeaderRefreshing() {
        if isLoading {
            BaseView.orginalInset.top = headerTopInset
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.scrollView!.contentInset = BaseView.orginalInset
            }, completion: { (complete) -> Void in
                self.imageView!.layer.removeAllAnimations()
                self.imageView!.image = UIImage(named: self.imagePath()!)
                self.imageView!.transform = CGAffineTransformIdentity
                self.isLoading = false
            })
        }
    }
    
    func adjustImageView(distance: CGFloat) {
        if !isRotate && distance == tigerValue {
            UIView.animateWithDuration(animationDuration) {
                self.imageView?.transform = CGAffineTransformMakeRotation(maxAngel)
            }
            isRotate = true
        } else if isRotate && distance > tigerValue {
            UIView.animateWithDuration(animationDuration) {
                self.imageView?.transform = CGAffineTransformIdentity
            }
            isRotate = false
        }
    }
}

