//
//  BaseView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/13.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class BaseView: UIView {
    static let HEADER_HEIGHT: CGFloat = 44
    static let FOOTER_HEIGHT: CGFloat = 44
    static var originOffset = CGPointZero
    static var originInset = UIEdgeInsetsZero
    
    weak var newSuperview: UIScrollView?
    
    var isSetUpObserve: Bool = false
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        self.removeFromSuperview()
        assert(newSuperview is UIScrollView, "父控件必须继承 UIScrollView ")
        self.newSuperview = newSuperview as? UIScrollView
    }
    
    func setUpViewFrame() {
        var frame = self.frame
        frame.size.width = newSuperview!.bounds.size.width
        frame.origin.x = 0
        if self is HeaderView {
            frame.size.height = BaseView.HEADER_HEIGHT
            frame.origin.y = -BaseView.HEADER_HEIGHT
        } else if self is FooterView {
            frame.size.height = BaseView.FOOTER_HEIGHT
            frame.origin.y = newSuperview!.contentSize.height
        }
        self.frame = frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViewFrame()
        if !isSetUpObserve {
            setUpObserver()
            isSetUpObserve = true
            BaseView.originInset = newSuperview!.contentInset
            BaseView.originOffset = newSuperview!.contentOffset
        }
    }
    
    // MARK: 子类初始化子控件的函数
    func setUpSubViews() {
        
    }
    
    func setUpObserver() {
    
    }

}
