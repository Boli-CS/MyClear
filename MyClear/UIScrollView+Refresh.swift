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
        let header:RefreshHeaderView = RefreshHeaderView.footer()
        self.addSubview(header)
        header.responseToHeadView = callback
        
        header.addState(RefreshState.normal)
    }
    
    func addFooterWithCallback( callback:(() -> Void)!){
        let footer:RefreshFooterView = RefreshFooterView.footer()
        
        self.addSubview(footer)
        footer.responseToFootView = callback
        
        footer.addState(RefreshState.normal)
    }

}