//
//  UIScrollView+Refresh.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-24.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit



extension UIScrollView {
    
    func addHeaderWithCallback( callback:((RefreshState) -> Void)!){
        var header:RefreshHeaderView = RefreshHeaderView.footer()
        self.addSubview(header)
        header.responseToHeadView = callback
        
        header.addState(RefreshState.normal)
    }
    
    func addFooterWithCallback( callback:(() -> Void)!){
        var footer:RefreshFooterView = RefreshFooterView.footer()
        
        self.addSubview(footer)
        footer.responseToFootView = callback
        
        footer.addState(RefreshState.normal)
    }

}