//
//  FooterView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class FooterView: BaseView {

    var footerImagePath = "ScrollViewResh.Bundle".stringByAppendingPathComponent("tableview_pull_refresh.png")
    private let FOOTER_HEIGHT:CGFloat = 44
    var currContentSize: CGSize = CGSizeZero
    var tigerValue: CGFloat = 60
    var rotateAngel: CGFloat = CGFloat(M_PI)
    var isRotate = false
    var footerTopInset: CGFloat = 0
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        footerTopInset = BaseView.orginalInset.bottom
        setUpHeaderViewSize()
    }
    
    func setUpHeaderViewSize() {
        let footerW = scrollView!.bounds.size.width
        let footerX: CGFloat = 0
        let footerY: CGFloat = scrollView!.contentSize.height + FOOTER_HEIGHT
        self.frame = CGRectMake(footerX, footerY, footerW, FOOTER_HEIGHT)
        self.hidden = true
        // 设置imageView的 transform
        imageView?.transform = CGAffineTransformMakeRotation( rotateAngel )
    }
    
    override func imagePath() -> String? {
        return footerImagePath
    }
    
    override func observerKeyPath() -> [String]? {
        return ["contentSize", "contentOffset"]
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "contentSize":
            let contentSize = (change["new"] as! NSValue).CGSizeValue()
            if !CGSizeEqualToSize(currContentSize, contentSize) {
                currContentSize = contentSize
                self.frame.origin.y = currContentSize.height
            }
        case "contentOffset":
            let contentOffset = (change["new"] as! NSValue).CGPointValue()
            let offset = contentOffset.y + scrollView!.bounds.size.height
            if  offset > self.frame.origin.y {
                self.hidden = false
                let footerShowing = offset - scrollView!.contentSize.height
                adjustImageView(footerShowing)
                beginFooterReFreshing()
                if !scrollView!.dragging {
                    beginFooterReFreshing()
                }
            } else {
                self.hidden = true
            }
        default :
            break
        }
        
    }
    
    func beginFooterReFreshing() {
        let offset = scrollView!.contentOffset.y + scrollView!.bounds.size.height
        let footerShowing = offset - scrollView!.contentSize.height
        if footerShowing > tigerValue && !isLoading {
            footerStartRefresh()
        }
    }
    
    func footerStartRefresh() {
        if isLoading { return }
        // 设置动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.duration = animationDuration
        anim.repeatCount = MAXFLOAT
        imageView!.layer.addAnimation(anim, forKey: nil)
        imageView!.image = loadingImage!
        // 滚动到指定位置
        let y = scrollView!.contentSize.height - scrollView!.bounds.height + self.bounds.height
        let contentOffset = CGPointMake(0,  y )
        BaseView.orginalInset.bottom = self.bounds.height
        scrollView!.contentInset = BaseView.orginalInset
        scrollView!.setContentOffset(contentOffset, animated: true)
        if block != nil {
            block!()
        }
        isLoading = true
    }
    
    func endFooterRefreshing() {
        if isLoading {
            BaseView.orginalInset.top = footerTopInset
            self.scrollView!.contentInset = BaseView.orginalInset
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.scrollView!.setContentOffset(CGPointMake(self.scrollView!.contentOffset.x, self.scrollView!.contentSize.height - self.scrollView!.bounds.height), animated: false)
            }, completion: { (complete) -> Void in
                self.imageView!.layer.removeAllAnimations()
                self.imageView!.image = UIImage(named: self.imagePath()!)
                self.imageView!.transform = CGAffineTransformMakeRotation( self.rotateAngel )
                self.isLoading = false
            })
        }
    }
    
    func adjustImageView(footerShowing: CGFloat) {
        if footerShowing > tigerValue && !isRotate {
            UIView.animateWithDuration(animationDuration) {
                self.imageView!.transform = CGAffineTransformIdentity
            }
            isRotate = true
        } else if footerShowing < tigerValue && isRotate {
            UIView.animateWithDuration(animationDuration) {
                self.imageView!.transform = CGAffineTransformMakeRotation(self.rotateAngel)
            }
            isRotate = false
        }
    }
}
