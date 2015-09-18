//
//  SecondaryPageBaseClass.swift
//  MyClear
//
//  Created by boli on 2/3/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class SecondaryPageBaseClass : UITableViewController{
    
    func addHeaderView() {
        self.tableView.addHeaderWithCallback { (state : RefreshState) -> Void in
            if state == RefreshState.back {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}