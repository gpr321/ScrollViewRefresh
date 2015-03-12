//
//  UIScrollView+FooterRefresh.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

extension UIScrollView {

    func addFooterRefresh() {
        addFooterView()
    }
    
    func addFooterView() {
        let footerView = FooterView()
        self.addSubview(footerView)
        objc_setAssociatedObject(self, unsafeAddressOf(FooterView.self), footerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func addFooterViewWithBlock(block: (() -> ())) {
        let footerView = FooterView(block: block)
        self.addSubview(footerView)
        objc_setAssociatedObject(self, unsafeAddressOf(FooterView.self), footerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func endFooterRefresh() {
        let footer = objc_getAssociatedObject(self, unsafeAddressOf(FooterView.self)) as! FooterView
        footer.endFooterRefreshing()
    }
    
    func beginFooterRefreshing() {
        let footer = objc_getAssociatedObject(self, unsafeAddressOf(FooterView.self)) as! FooterView
        footer.footerStartRefresh()
    }
}
