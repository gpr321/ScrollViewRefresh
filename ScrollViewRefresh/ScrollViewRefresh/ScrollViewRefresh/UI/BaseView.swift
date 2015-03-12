//
//  BaseView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class BaseView: UIView {
    static let titleLabelFontSize: CGFloat = 14
    static let MARGIN: CGFloat = 8
    private weak var titleLabel: UILabel?
    weak var imageView: UIImageView?
    var loadingImage = UIImage(named: "ScrollViewResh.Bundle".stringByAppendingPathComponent("tableview_loading.png"))
    var refreshTitle: String = "数据正在刷新中..." {
        didSet {
            titleLabel?.text = refreshTitle
        }
    }
    var animationDuration: NSTimeInterval = 0.5
    var isLoading = false
    weak var scrollView: UIScrollView?
    // 记录 scrollView 最原始的 UIEdgeInsets
    static var orginalInset = UIEdgeInsetsZero
    weak var target: NSObject?
    var action: Selector?
    var block: (() -> ())?
    
    override init() {
        super.init()
    }
    
    init(target: NSObject, action: Selector) {
        super.init()
        self.target = target
        self.action = action
    }
    
    init(block: (() -> ())) {
        super.init()
        self.block = block
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewW = self.bounds.size.width
        let viewH = self.bounds.size.height
        let imgVW = imageView?.bounds.size.width
        let imgVH = imageView?.bounds.size.height
        let labelW = titleLabel?.bounds.width
        let labelH = titleLabel?.bounds.height
        
        let imgX = (viewW - imgVW! - BaseView.MARGIN - labelW!) * 0.5
        let imgY = 0.5 * (viewH - imgVH!)
        imageView!.frame = CGRectMake(imgX, imgY, imgVW!, imgVH!)
        
        let labelX = BaseView.MARGIN + CGRectGetMaxX(imageView!.frame)
        let labelY = 0.5 * (viewH - labelH!)
        titleLabel!.frame = CGRectMake(labelX, labelY, labelW!, labelH!)
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        assert(newSuperview is UIScrollView, "父控件必须为scrollView")
        if let keyPaths = self.observerKeyPath() {
            for itemPath in keyPaths {
                superview?.removeObserver(self, forKeyPath: itemPath)
                newSuperview?.addObserver(self, forKeyPath: itemPath, options: NSKeyValueObservingOptions.New, context: nil)
            }
        }
        scrollView = (newSuperview as! UIScrollView)
        BaseView.orginalInset = scrollView!.contentInset
    }
    
    deinit {
        if let keyPaths = self.observerKeyPath() {
            for itemPath in keyPaths {
                superview?.removeObserver(self, forKeyPath: itemPath)
            }
        }
    }
    
    func setUpSubViews() {
        let titleLabel = UILabel()
        titleLabel.text = refreshTitle
        titleLabel.font = UIFont.systemFontOfSize(BaseView.titleLabelFontSize)
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: self.imagePath()!)
        imageView.sizeToFit()
        self.addSubview(imageView)
        self.imageView = imageView
    }
    
    func imagePath() -> String? {
        return nil
    }
    
    func observerKeyPath() -> [String]? {
        return nil
    }
}
