//
//  StatusView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/13.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

enum Status {
    case Normal             // 空闲
    case RotateBack         // 箭头指向跟开始相反
    case Loading            // 图标正在转动
}

class StatusView: UIView {
    weak var label: UILabel?
    weak var imageView: UIImageView?
    let margin: CGFloat = 10
    var animationDuration: NSTimeInterval = 0.5
    
    var state: Status = .Normal {
        didSet {
            switch state {
            case .Normal:
                setUpNormal()
            case .RotateBack:
                setUpRotateBack()
            case .Loading:
                setUpLoading()
            default:
                break
            }
        }
    }
    
    var arrowImage = UIImage(named: "ScrollViewResh.Bundle".stringByAppendingPathComponent("tableview_pull_refresh.png"))
    let loadingImage =  UIImage(named: "ScrollViewResh.Bundle".stringByAppendingPathComponent("tableview_loading.png"))
    
    var refreshingText: String? {
        didSet {
            self.label!.text = refreshingText!
            self.layoutSubviews()
        }
    }
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        self.addSubview(label)
        self.label = label
        
        let imageView = UIImageView()
        imageView.image = arrowImage!
        imageView.sizeToFit()
        self.addSubview(imageView)
        self.imageView = imageView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label!.sizeToFit()
        let centerX = self.bounds.size.width * 0.5
        let centerY = self.bounds.size.height * 0.5
        let labeCenterY = centerY
        let labelCenterX = centerX + 0.5 *  imageView!.bounds.size.width + margin
        label!.center = CGPointMake(labelCenterX, labeCenterY)
        
        let imageViewCenterY = centerY
        let imageViewCenterX = label!.frame.origin.x - margin - imageView!.bounds.size.width * 0.5
        imageView!.center = CGPointMake(imageViewCenterX, imageViewCenterY)
    }
    
    // MARK: state -> RotateBack
    func setUpRotateBack() {
        UIView.animateWithDuration(animationDuration) {
            self.imageView!.transform = CGAffineTransformMakeRotation( CGFloat(M_PI) )
        }
    }
    
    // MARK: state -> Normal
    func setUpNormal() {
        imageView!.layer.removeAllAnimations()
        imageView!.image = arrowImage!
        UIView.animateWithDuration(animationDuration) {
            self.imageView!.transform = CGAffineTransformIdentity
        }
    }
    
    // MARK: state -> Loading
    func setUpLoading() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.duration = animationDuration
        anim.repeatCount = MAXFLOAT
        imageView!.image = loadingImage
        imageView!.layer.addAnimation(anim, forKey: nil)
    }

}
