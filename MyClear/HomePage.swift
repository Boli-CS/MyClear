//
//  ViewController.swift
//  MyClear
//
//  Created by boli on 1/19/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class HomePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homePageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.homePageTableView.dataSource = self
        
        //隐藏空白item
        var tblView =  UIView(frame: CGRectZero)
        homePageTableView.tableFooterView = tblView
        homePageTableView.tableFooterView?.hidden = true
        homePageTableView.backgroundColor = UIColor.clearColor()
//        var tblView =  UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
//        tblView.backgroundColor = UIColor.clearColor()
//        homePageTableView.tableFooterView = tblView
        
        var nipName=UINib(nibName: "CustomCell", bundle:nil)
        self.homePageTableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("mylistcell") as MyListCell
            cell.myListCell_todoNum_label.text = "1"
            return cell
            break;
        case 1:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("soundcell") as SoundCell
            return cell
            break;
        case 2:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("themecell") as ThemeCell
            return cell
            break;
        case 3:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("tipandtrickcell") as TipTrickCell
            return cell
            break;
        case 4:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("newslettercell") as NewsLetterCell
            return cell
            break;
        case 5:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("settingcell") as SettingCell
            return cell
            break;
        default:
            let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("soundcell") as SoundCell
            return cell
            break
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {    }
    
    override func setEditing(editing: Bool, animated: Bool) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setting" {
            var vc = segue.destinationViewController as SettingPage
            // var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
            }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.item)
    }

}

