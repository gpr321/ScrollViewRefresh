//
//  HeaderView.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/13.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class HeaderView: BaseView {
    weak var statusView: StatusView?
    var targetValue: CGFloat = -60
    var block: (() -> ())?
    
    override func setUpSubViews() {
        let statusView = StatusView()
        self.addSubview(statusView)
        self.statusView = statusView
        statusView.refreshingText = "数据正在刷新中..."
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusView!.frame = self.bounds
    }
    
    override func setUpObserver() {
        newSuperview?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        let y = newSuperview!.contentInset.top + newSuperview!.contentOffset.y
        if statusView!.state == .Loading { return }
        if y < targetValue {
            if !newSuperview!.dragging {
                beginHeaderRefresh()
            }
            if statusView!.state != .RotateBack {
                statusView!.state = .RotateBack
            }
        } else if y > targetValue {
            // 在拖拽的状态下根据位移调整箭头的方向
            if newSuperview!.dragging && statusView!.state != .Normal{
                 statusView!.state = .Normal
            }
        }
    }
    
    func beginHeaderRefresh() {
        if statusView!.state == .Loading { return }
        statusView!.state = .Loading
        let offset = newSuperview!.contentOffset
        BaseView.originInset.top += self.frame.size.height
        newSuperview!.contentInset = BaseView.originInset
        BaseView.originOffset.y += (-self.frame.size.height)
        newSuperview?.setContentOffset(BaseView.originOffset, animated: true)
        if block != nil {
            block!()
        }
    }

    func endHeaderRefresh() {
        if statusView!.state == .Normal { return }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            BaseView.originInset.top -= self.frame.size.height
            self.newSuperview!.contentInset = BaseView.originInset
            BaseView.originOffset.y += (self.frame.size.height)
            self.newSuperview!.setContentOffset(BaseView.originOffset, animated: false)
            }) { (complete) -> Void in
                self.statusView!.state = .Normal
        }
    }
}
