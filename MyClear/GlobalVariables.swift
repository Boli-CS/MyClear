//
//  GlobalVariables.swift
//  MyClear
//
//  Created by boli on 9/12/15.
//  Copyright (c) 2015 boli. All rights reserved.
//  保存全局参数信息

import Foundation
import UIKit
import SQLite

public class GlobalVariables {

    static var currentTheme : Int64 = 0;
    
    static let dbPath = NSHomeDirectory() + "/Documents/db.sqlite3";
    
    static let listTable = Table("List")
    public struct List {
        static let id = Expression<Int64>("id")
        static let listName = Expression<String>("ListName")
    }
    
    static let themeTable = Table("Theme")
    public struct Theme {
        static let themeID = Expression<Int64>("ThemeID")
    }
    
    static let todoThingTable = Table("TodoThing")
    public struct TodoThing {
        static let id = Expression<Int64>("ID")
        static let deadLine = Expression<Int64>("DeadLine")
        static let listID = Expression<Int64>("ListID")
        static let thing = Expression<String>("Thing")
        
    }
}



extension UIColor {
    
    func getRed() -> Int {
        return (self.rgb()! & 0x00FF0000) >> 16
    }
    
    func getBlue() -> Int{
        return self.rgb()! & 0x000000FF
    }
    
    func getGreen() -> Int{
        return self.rgb()! & 0x0000FF00 >> 8
    }
    
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}