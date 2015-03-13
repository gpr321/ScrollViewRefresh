//
//  UIScrollView+FooterRefresh.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/13.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func addFooterView() {
        let footerView = FooterView()
        footerView.backgroundColor = UIColor.redColor()
        self.addSubview(footerView)
        setFooterView(footerView)
    }
    
    func setFooterView(footerView: FooterView) {
        objc_setAssociatedObject(self, unsafeAddressOf(FooterView.self), footerView, UInt(OBJC_ASSOCIATION_ASSIGN))
    }
    
    func footerView() -> FooterView {
        return objc_getAssociatedObject(self, unsafeAddressOf(FooterView.self)) as! FooterView
    }
    
}
