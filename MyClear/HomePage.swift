//
//  ViewController.swift
//  MyClear
//
//  Created by boli on 1/19/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

var lists_db : [AnyObject]! = []
var todoThings_db : [AnyObject]! = []

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
        
        //保存一份数据
//        saveData()
        
        loadData()
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
            if let var count : Int = listDomains?.count {
                cell.homePageCell_todoNum_label.text = "\(count)"
            }
            else {
                cell.homePageCell_todoNum_label.text = "0"
            }
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") as UIViewController;
        switch indexPath.item {
        case 0:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("mylist") as UIViewController
            break;
        case 1:
            vc  = mainStoryboard.instantiateViewControllerWithIdentifier("sound") as UIViewController
            break;
        case 2:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("theme") as UIViewController
            break;
        case 3:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("tiptrick") as UIViewController
            break;
        case 4:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("newletter") as UIViewController
            break;
        case 5:
            vc = mainStoryboard.instantiateViewControllerWithIdentifier("setting") as UIViewController
            break;
        default:
            break;
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func saveData() {
        //List
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        var firstrow : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context!)
        firstrow.setValue(1, forKey: "id")
        firstrow.setValue("firstList", forKey: "listname")
        context?.save(nil)
       
        var secondrow : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context!)
        secondrow.setValue(2, forKey: "id")
        secondrow.setValue("secondList", forKey: "listname")
        context?.save(nil)
        
        var firstThing : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("TodoThing", inManagedObjectContext: context!)
        firstThing.setValue(NSDate(), forKey: "deadline")
        firstThing.setValue(1, forKey: "id")
        firstThing.setValue(1, forKey: "listid")
        firstThing.setValue("firstThing", forKey: "thing")
        context?.save(nil)

        var secondThing : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("TodoThing", inManagedObjectContext: context!)
        secondThing.setValue(NSDate(), forKey: "deadline")
        secondThing.setValue(2, forKey: "id")
        secondThing.setValue(1, forKey: "listid")
        secondThing.setValue("secondThing", forKey: "thing")
        context?.save(nil)
        
        var thirdThing : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("TodoThing", inManagedObjectContext: context!)
        thirdThing.setValue(NSDate(), forKey: "deadline")
        thirdThing.setValue(3, forKey: "id")
        thirdThing.setValue(2, forKey: "listid")
        thirdThing.setValue("thirdThing", forKey: "thing")
        context?.save(nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //读取数据
        loadData()
    }
    
    func loadData() {
        println("loaddata")
        //coreData
        listDomains.removeAll(keepCapacity: false)
        
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        //list
        var listsFetchRequest = NSFetchRequest(entityName: "List")
        lists_db = context?.executeFetchRequest(listsFetchRequest, error: nil)
        for(var index = 0; index < lists_db?.count; index++) {
            var listdomain : ListDomain = ListDomain();
            listdomain.id = lists_db[index].valueForKey("id")?.intValue
            listdomain.listName = lists_db[index].valueForKey("listname") as String
            listDomains.append(listdomain)
        }
        
        //todoThing
        var todoThingsFetchRequest = NSFetchRequest(entityName: "TodoThing")
        todoThings_db = context?.executeFetchRequest(todoThingsFetchRequest, error: nil)
        for(var index = 0; index < todoThings_db?.count; index++){
            var todoThingDomain : TodoThingDomain = TodoThingDomain()
            todoThingDomain.id = todoThings_db[index].valueForKey("id")?.intValue
            todoThingDomain.deadLine = todoThings_db[index].valueForKey("deadline") as NSDate
            todoThingDomain.listID = todoThings_db[index].valueForKey("listid")?.intValue
            todoThingDomain.thing = todoThings_db[index].valueForKey("thing") as String
            
            for(var listindex = 0; listindex < listDomains.count; listindex++) {
                if listDomains[listindex].id == todoThingDomain.listID {
                    listDomains[listindex].todoThingDomains?.append(todoThingDomain)
                }
            }
        }
    }
}

