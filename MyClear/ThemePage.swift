//
//  ThemePage.swift
//  MyClear
//
//  Created by boli on 1/21/15.
//  Copyright (c) 2015 boli. All rights reserved.
//


import UIKit

class ThemePage: UITableViewController, UITableViewDelegate {
    
    @IBOutlet weak var themes_themePage_UITableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = themes_themePage_UITableView.dequeueReusableCellWithIdentifier("themeCell_reuesIdentifier") as! ThemeCell
        cell.themeName_themeCell_label.text = themes[indexPath.item].themeName;
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //渐变的背景颜色
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [themes[indexPath.item].startColor.CGColor, themes[indexPath.item].endColor.CGColor]
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(0, 1)
        
        gradientLayer.frame = cell.bounds
        cell.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
}