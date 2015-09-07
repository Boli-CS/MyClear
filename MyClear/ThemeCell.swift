//
//  ThemeCell.swift
//  MyClear
//
//  Created by boli on 9/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import Foundation
import UIKit

public struct theme_color {
    public var themeName : String
    public var startColor : UIColor
    public var endColor : UIColor
    
    init(themeName : String, startColor : UIColor, endColor : UIColor) {
        self.themeName = themeName
        self.startColor = startColor
        self.endColor = endColor
    }
}

var themes : Array<theme_color> = [
    theme_color(themeName : "red",
        startColor : UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1),
        endColor : UIColor(red: 255.0, green: 125.0, blue: 125.0, alpha: 1)),
    theme_color(themeName : "blue",
        startColor : UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 1),
        endColor : UIColor(red: 125.0, green: 125.0, blue: 255.0, alpha: 1))
]


class ThemeCell : UITableViewCell{
    
    @IBOutlet weak var themeName_themeCell_label: UILabel!
    
    
    
    
}
