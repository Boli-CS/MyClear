//
//  ViewController.swift
//  MyClear
//
//  Created by boli on 1/19/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class HomePage: UITableViewController {
    
    @IBOutlet weak var homePageTableView: UITableView!
    
    let homePageCell_textField = ["My Lists", "Sounds", "Theme", "Tips & Tricks", "NewsLetter", "Settings"]
    
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
        self.homePageTableView.registerNib(nipName, forCellReuseIdentifier: "Custo)mCell")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePageCell_textField.count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("homepagecell") as HomePageCell
        cell.homePageCell_textFied.text = self.homePageCell_textField[indexPath.item]
        if indexPath.item == 0 {
            cell.homePageCell_todoNum_label.text = "1"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        switch indexPath.item {
        case 0:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        case 1:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sound") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        case 2:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("theme") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        case 3:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("tiptrick") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        case 4:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("newletter") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        case 5:
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("setting") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
        default:
            break;
        }
        
    }

}

