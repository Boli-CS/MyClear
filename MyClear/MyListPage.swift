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
        //修改数据库入库
        for(var index = 0; index < lists_db.count; index++) {
            println(lists_db[index].valueForKey("id"))
            if (sender as myListCell_textField).id! == lists_db[index].valueForKey("id")?.intValue {
                var data = lists_db[index] as NSManagedObject
                data.setValue((sender as myListCell_textField).text, forKey: "listname")
                data.managedObjectContext?.save(nil)
                
            }
        }

        //修改domain
        for(var index = 0; index < listDomains.count; index++) {
            if (sender as myListCell_textField).id! == listDomains[index].id {
                listDomains[index].listName = (sender as myListCell_textField).text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addHeaderView()
        
        //隐藏空白item
        var tblView =  UIView(frame: CGRectZero)
        myListPage_tableView.tableFooterView = tblView
        myListPage_tableView.tableFooterView?.hidden = true
        myListPage_tableView.backgroundColor = UIColor.clearColor()
        var nipName=UINib(nibName: "CustomCell", bundle:nil)
        self.myListPage_tableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDomains.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myListPage_tableView.dequeueReusableCellWithIdentifier("mylistcell_identifier") as MyListCell
        cell.listName_myListCell_textField.text = listDomains[indexPath.row].listName
        if let var count : Int = listDomains[indexPath.row].todoThingDomains?.count {
            cell.listCount_label.text = "\(count)"
        }
        cell.listName_myListCell_textField.id = listDomains[indexPath.row].id
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc  = mainStoryboard.instantiateViewControllerWithIdentifier("mytodopage") as MyTodoPage
        vc.listID = listDomains[indexPath.row].id
        self.presentViewController(vc, animated: true, completion: nil)
    }
}