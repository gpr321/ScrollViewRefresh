//
//  UIScrollView+HeaderRefresh.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func addHeaderRefresh() {
        addHeaderView()
    }
    
    func addHeaderView() {
        let headerView = HeaderView()
        self.addSubview(headerView)
        objc_setAssociatedObject(self, unsafeAddressOf(HeaderView.self), headerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func addHeaderViewWithBlock(block: (() -> ())) {
        let headerView = HeaderView(block: block)
        self.addSubview(headerView)
        objc_setAssociatedObject(self, unsafeAddressOf(HeaderView.self), headerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func endHeaderRefresh() {
        let headerView = objc_getAssociatedObject(self, unsafeAddressOf(HeaderView.self)) as! HeaderView
        headerView.endHeaderRefreshing()
    }
    
    func beginHeaderRefreshing() {
        let headerView = objc_getAssociatedObject(self, unsafeAddressOf(HeaderView.self)) as! HeaderView
        headerView.endHeaderRefreshing()
        headerView.headerStartRefresh()
    }
}


