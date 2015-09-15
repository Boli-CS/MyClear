//
//  ViewController.swift
//  MyClear
//
//  Created by boli on 1/19/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import SQLite

func loadDataFromDataBase () {
    
    //coreData
    listDomains.removeAll(keepCapacity: false)

    let db = Database(GlobalSetting.dbPath)
    //list
    for list in db[GlobalSetting.listTableName] {
        var listdomain : ListDomain = ListDomain();
        listdomain.id = list[GlobalSetting.List.id]
        listdomain.listName = list[GlobalSetting.List.listName]
        listDomains.append(listdomain)

    }
    
    //todoThing
    for todoThing in db[GlobalSetting.todoThingTableName]{
        var todoThingDomain : TodoThingDomain = TodoThingDomain()
        todoThingDomain.id = todoThing[GlobalSetting.TodoThing.id]
        todoThingDomain.deadLine = todoThing[GlobalSetting.TodoThing.deadLine]
        todoThingDomain.listID = todoThing[GlobalSetting.TodoThing.listID]
        todoThingDomain.thing = todoThing[GlobalSetting.TodoThing.thing]
        
        for(var listindex = 0; listindex < listDomains.count; listindex++) {
            if listDomains[listindex].id == todoThingDomain.listID {
                listDomains[listindex].todoThingDomains?.append(todoThingDomain)
            }
        }
    }
}

func loadTheme() {
    
    let db = Database(GlobalSetting.dbPath)
    //list
    if(db[GlobalSetting.themeTableName].count > 0) {
        GlobalSetting.currentTheme = db[GlobalSetting.themeTableName].first![GlobalSetting.Theme.themeID]
    }
    else {
        db[GlobalSetting.themeTableName].insert(GlobalSetting.Theme.themeID <- 0)
    }
}

class HomePage: UITableViewController {
    
    @IBOutlet weak var homePageTableView: UITableView!
    
    let homePageCell_textField = ["My Lists", "Sounds", "Theme", "Tips & Tricks", "NewsLetter", "Settings"]
    
    var storyboadrID = "mylist"
    
    func addFootView() {
        self.tableView.addFooterWithCallback { () -> Void in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(self.storyboadrID) as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.homePageTableView.dataSource = self
        
        //隐藏空白item
//        var tblView =  UIView(frame: CGRectZero)
//        homePageTableView.tableFooterView = tblView
//        homePageTableView.tableFooterView?.hidden = true
//        homePageTableView.backgroundColor = UIColor.clearColor()
//        var tblView =  UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
//        tblView.backgroundColor = UIColor.clearColor()
//        homePageTableView.tableFooterView = tblView
        var nipName=UINib(nibName: "CustomCell", bundle:nil)
        self.homePageTableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //加载theme信息
        loadTheme()
        
        loadDataFromDataBase()
        
        addFootView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePageCell_textField.count

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.homePageTableView.dequeueReusableCellWithIdentifier("homepagecell") as! HomePageCell
        cell.homePageCell_textFied.text = self.homePageCell_textField[indexPath.item]
        if indexPath.item == 0 {
            if let var count : Int = listDomains?.count {
                cell.homePageCell_todoNum_label.text = "\(count)"
            }
            else {
                cell.homePageCell_todoNum_label.text = "0"
            }
            
        }
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "HomePageCellBackground")!)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") as! UIViewController;
        switch indexPath.item {
        case 0:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") as!UIViewController
            storyboadrID = "mylist"
            break;
        case 1:
            vc  = mainStoryboard.instantiateViewControllerWithIdentifier("sound") as! UIViewController
            storyboadrID = "sound"
            break;
        case 2:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("theme") as! UIViewController
            storyboadrID = "theme"
            break;
        case 3:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("tiptrick") as! UIViewController
            storyboadrID = "tiptrick"
            break;
        case 4:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("newletter") as! UIViewController
            storyboadrID = "newletter"
            break;
        case 5:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("setting") as! UIViewController
            storyboadrID = "setting"
            break;
        default:
            break;
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        //读取数据
        loadDataFromDataBase()
        self.homePageTableView.reloadData();
    }
}

