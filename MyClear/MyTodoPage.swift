//
//  MyTodoPage.swift
//  MyClear
//
//  Created by boli on 2/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class MyTodoPage: UITableViewController {

    var listID : Int32?;
    var todoThings : [TodoThingDomain] = []
    
    @IBOutlet var myTodoList_tableView: UITableView!
    
    func addHeadView() {
        self.myTodoList_tableView.addHeaderWithCallback {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        loadData();
        self.addHeadView()
        
        //隐藏空白item
        var tblView =  UIView(frame: CGRectZero)
        myTodoList_tableView.tableFooterView = tblView
        myTodoList_tableView.tableFooterView?.hidden = true
        myTodoList_tableView.backgroundColor = UIColor.clearColor()
        var nipName=UINib(nibName: "CustomCell", bundle:nil)
        self.myTodoList_tableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func loadData() {
        todoThings.removeAll(keepCapacity: false)
        for(var index = 0; index < listDomains.count; index++) {
            if listDomains[index].id == listID {
                todoThings = listDomains[index].todoThingDomains!
            }
        }
    }
    
    @IBAction func myTodoCell_textField_editingDidEnd(sender: AnyObject) {
        //database
        for(var index = 0; index < todoThings_db.count; index++) {
            if todoThings_db[index].valueForKey("id")?.intValue == (sender as MyTodoCellTextField).id {
                var data = todoThings_db[index] as NSManagedObject
                data.setValue((sender as MyTodoCellTextField).text, forKey: "thing")
                data.managedObjectContext?.save(nil)
            }
        }
        
        //domain
        for(var index = 0; index < todoThings.count; index++) {
            if todoThings[index].id == (sender as MyTodoCellTextField).id {
                todoThings[index].thing = (sender as MyTodoCellTextField).text
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoThings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(self.myTodoList_tableView)
        let cell = myTodoList_tableView.dequeueReusableCellWithIdentifier("mytodocell_identifier") as MyTodoCell
        cell.todoThingName_myTodoCellTextField.text = todoThings[indexPath.row].thing
        cell.todoThingName_myTodoCellTextField.id = todoThings[indexPath.row].id
        return cell
    }
    
}
