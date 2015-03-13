//
//  UIScrollView+HeaderRefresh.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/13.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

extension UIScrollView {

    func addHeaderView() {
        let headerView = HeaderView()
        self.addSubview(headerView)
        setHeaderView(headerView)
    }
    
    func addHeaderViewWithBlock(block: (() -> ())) {
        let headerView = HeaderView()
        headerView.block = block
        self.addSubview(headerView)
        setHeaderView(headerView)
    }
    
    func setHeaderView(headerView: HeaderView) {
        objc_setAssociatedObject(self, unsafeAddressOf(HeaderView.self), headerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func headerView() -> HeaderView {
        return objc_getAssociatedObject(self, unsafeAddressOf(HeaderView.self)) as! HeaderView
    }
    
    func beginHeaderRefresh() {
        headerView().beginHeaderRefresh()
    }
    
    func endHeaderRefresh() {
        headerView().endHeaderRefresh()
    }
    
}
