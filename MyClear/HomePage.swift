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

    let db = try! Connection(GlobalVariables.dbPath)
    //list
    for list in db.prepare(GlobalVariables.listTable) {
        let listdomain : ListDomain = ListDomain();
        listdomain.id = list[GlobalVariables.List.id]
        listdomain.listName = list[GlobalVariables.List.listName]
        listDomains.append(listdomain)

    }
    
    //todoThing
    for todoThing in db.prepare(GlobalVariables.todoThingTable){
        let todoThingDomain : TodoThingDomain = TodoThingDomain()
        todoThingDomain.id = todoThing[GlobalVariables.TodoThing.id]
        todoThingDomain.deadLine = todoThing[GlobalVariables.TodoThing.deadLine]
        todoThingDomain.listID = todoThing[GlobalVariables.TodoThing.listID]
        todoThingDomain.thing = todoThing[GlobalVariables.TodoThing.thing]
        
        for(var listindex = 0; listindex < listDomains.count; listindex++) {
            if listDomains[listindex].id == todoThingDomain.listID {
                listDomains[listindex].todoThingDomains?.append(todoThingDomain)
            }
        }
    }
}

func loadTheme() {
    
    let db = try! Connection(GlobalVariables.dbPath)
    //list
    if(db.scalar(GlobalVariables.themeTable.count) > 0) {
        for user in db.prepare(GlobalVariables.themeTable) {
            GlobalVariables.currentTheme = user[GlobalVariables.Theme.themeID]
            print("GlobalVariables.currentTheme:" + String(GlobalVariables.currentTheme))
        }
        
    }
    else {
        do {
            try db.run(GlobalVariables.themeTable.insert(GlobalVariables.Theme.themeID <- 0))
        } catch let error {
            print(error)
        }
    }
}

class HomePage: UITableViewController {
    
    @IBOutlet weak var homePageTableView: UITableView!
    
    let homePageCell_textField = ["My Lists", "Sounds", "Theme", "Tips & Tricks", "NewsLetter", "Settings"]
    
    var storyboadrID = "mylist"
    
    func addFootView() {
        self.tableView.addFooterWithCallback { () -> Void in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(self.storyboadrID) 
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.homePageTableView.dataSource = self
        
        let nipName=UINib(nibName: "CustomCell", bundle:nil)
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
        cell.homePageCell_textFied.enabled = false
        if indexPath.item == 0 {
            if let count : Int = listDomains?.count {
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
        var vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") ;
        switch indexPath.item {
        case 0:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") 
            storyboadrID = "mylist"
            break;
        case 1:
            vc  = mainStoryboard.instantiateViewControllerWithIdentifier("sound") 
            storyboadrID = "sound"
            break;
        case 2:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("theme") 
            storyboadrID = "theme"
            break;
        case 3:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("tiptrick") 
            storyboadrID = "tiptrick"
            break;
        case 4:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("newletter") 
            storyboadrID = "newletter"
            break;
        case 5:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("setting") 
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

