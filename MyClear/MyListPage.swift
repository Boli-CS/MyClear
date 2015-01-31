//
//  MyListPage.swift
//  MyClear
//
//  Created by boli on 1/21/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import CoreData


var listDomains : [ListDomain]! = []

class MyListPage: UITableViewController {
    
    @IBOutlet weak var myListPage_tableView: UITableView!

    func addHeaderView() {
        self.tableView.addHeaderWithCallback({
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("homepage") as UIViewController
//            self.presentViewController(vc, animated: true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)

        })
        
        
//        self.tableView.addFooterWithCallback({
//            print("2")
//        })
    }
    
    @IBAction func myListCell_textField_editingDidEnd(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addHeaderView()
        
        
        loadData()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDomains.count;
//        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myListPage_tableView.dequeueReusableCellWithIdentifier("mylistcell_identifier") as MyListCell
        cell.myListCell_textField.text = listDomains[indexPath.row].listName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func loadData() {
        //coreData
        listDomains.removeAll(keepCapacity: false)
        
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        //list
        var listsFetchRequest = NSFetchRequest(entityName: "List")
        var lists : [AnyObject]! = context?.executeFetchRequest(listsFetchRequest, error: nil)
        for(var index = 0; index < lists?.count; index++) {
            var listdomain : ListDomain = ListDomain();
            listdomain.id = lists[index].valueForKey("id")?.intValue
            listdomain.listName = lists[index].valueForKey("listname") as String
            listDomains.append(listdomain)
        }
        
        //todoThing
        var todoThingsFetchRequest = NSFetchRequest(entityName: "TodoThing")
        var todoThings : [AnyObject]! = context?.executeFetchRequest(todoThingsFetchRequest, error: nil)
        for(var index = 0; index < todoThings?.count; index++){
            var todoThingDomain : TodoThingDomain = TodoThingDomain()
            todoThingDomain.id = todoThings[index].valueForKey("id")?.intValue
            todoThingDomain.deadLine = todoThings[index].valueForKey("deadline") as NSDate
            todoThingDomain.listID = todoThings[index].valueForKey("listid")?.intValue
            todoThingDomain.thing = todoThings[index].valueForKey("thing") as String
            
            println(todoThingDomain.id)
            println(todoThingDomain.deadLine)
            println(todoThingDomain.listID)
            println(todoThingDomain.thing)
            println("-----------")

            for(var listindex = 0; listindex < listDomains.count; listindex++) {
                if listDomains[listindex].id == todoThingDomain.listID {
                    listDomains[listindex].todoThingDomains?.append(todoThingDomain)
                }
            }
        }
    }
    
}