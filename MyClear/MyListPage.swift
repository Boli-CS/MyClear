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
        self.tableView.addHeaderWithCallback { (var state : RefreshState) -> Void in
            if state == RefreshState.back {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if state == RefreshState.addNewItem {
                var maxID : Int32 = 0;
                for(var index = 0; index < listDomains.count; index++) {
                    if listDomains[index].id > maxID {
                        maxID = listDomains[index].id!
                    }
                }
                var listDomain : ListDomain = ListDomain()
                listDomain.id = maxID + 1
                listDomain.listName = ""
                listDomain.todoThingDomains = []
                listDomains.insert(listDomain, atIndex: 0)
                println(listDomains.count)
                self.myListPage_tableView.reloadData()
                
            }
        }
        
        
        
//        self.tableView.addFooterWithCallback({
//            print("2")
//        })
    }
    
    func backToPreviousView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func myListCell_textField_editingDidEnd(sender: AnyObject) {
        var thisTextField = sender as myListCell_textField
        var isNewItem = true
        var matchedIndex = -1
        
        for(var index = 0; index < lists_db.count; index++) {
            if lists_db[index].valueForKey("id")?.intValue == thisTextField.id {
                isNewItem = false
                matchedIndex = index
            }
        }
        if isNewItem {
            //新加list
            if thisTextField.text.isEmpty {
                listDomains.removeAtIndex(0)
                self.myListPage_tableView.reloadData()
            }
            else {
                var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
                var firstrow : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context!)
                firstrow.setValue(Int(thisTextField.id!), forKey: "id")
                firstrow.setValue(thisTextField.text, forKey: "listname")
                context?.save(nil)
                loadDataFromDataBase()
                
            }
        }
        else {
            //修改数据库入库
            var data = lists_db[matchedIndex] as NSManagedObject
            data.setValue(thisTextField.text, forKey: "listname")
            data.managedObjectContext?.save(nil)
            
            //修改domain
            for(var index = 0; index < listDomains.count; index++) {
                if thisTextField.id! == listDomains[index].id {
                    listDomains[index].listName = thisTextField.text
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addHeaderView()
        
//        var nipName=UINib(nibName: "CustomCell", bundle:nil)
//        self.myListPage_tableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
//        self.navigationController?.setNavigationBarHidden(true, animated: false)

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
        if cell.listName_myListCell_textField.text.isEmpty {
            println(cell.listName_myListCell_textField.text)
            println(cell.listName_myListCell_textField.text.isEmpty)
            cell.listName_myListCell_textField.becomeFirstResponder()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc  = mainStoryboard.instantiateViewControllerWithIdentifier("mytodopage") as MyTodoPage
        vc.listID = listDomains[indexPath.row].id
        self.presentViewController(vc, animated: true, completion: nil)
    }
}