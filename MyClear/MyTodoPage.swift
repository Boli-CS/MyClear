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
    var todoThings : [AnyObject] = []
    
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
    }
    
    func loadData() {
        todoThings.removeAll(keepCapacity: false)
        for(var index = 0; index < todoThings_db.count; index++) {
            if todoThings_db[index].valueForKey("listid")?.intValue == listID {
                todoThings.append(todoThings_db[index])
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoThings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(self.myTodoList_tableView)
        let cell = myTodoList_tableView.dequeueReusableCellWithIdentifier("mytodocell_identifier") as MyTodoCell
        cell.todoThingName_myTodoCellTextField.text = todoThings[indexPath.row].valueForKey("thing") as String
        cell.id = todoThings[indexPath.row].valueForKey("id")?.intValue
        return cell
    }
    
}
