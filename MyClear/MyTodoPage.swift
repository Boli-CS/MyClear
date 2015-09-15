//
//  MyTodoPage.swift
//  MyClear
//
//  Created by boli on 2/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import SQLite

class MyTodoPage: UITableViewController, UITextViewDelegate {

    var listID : Int64 = -1;
    var todoThings : [TodoThingDomain] = []
    
    var emptyCell : MyTodoCell?
    
    var thingColorRed : CGFloat = 217;
    var thingColorGreed : CGFloat = 0;
    var thingColorBlue : CGFloat = 22;
    let db = Database(GlobalSetting.dbPath);
    
    @IBOutlet var myTodoList_tableView: UITableView!
    
    func addHeadView() {
        self.myTodoList_tableView.addHeaderWithCallback { (var state : RefreshState) -> Void in
            if RefreshState.back == state {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if RefreshState.addNewItem == state {
                var maxID : Int64 = -1
                var newItem : TodoThingDomain = TodoThingDomain()
                newItem.deadLine = 1
                newItem.listID = self.listID
                newItem.thing = ""
                for(var index = 0; index < self.todoThings.count; index++) {
                    maxID = self.todoThings[index].id > maxID ? self.todoThings[index].id : maxID
                }
                newItem.id = maxID + 1
                self.todoThings.insert(newItem, atIndex: 0)
                self.myTodoList_tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadData();
        self.addHeadView()
        
//        var nipName=UINib(nibName: "CustomCell", bundle:nil)
//        self.myTodoList_tableView.registerNib(nipName, forCellReuseIdentifier: "CustomCell")
//        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func loadData() {
        todoThings.removeAll(keepCapacity: false)
        for(var index = 0; index < listDomains.count; index++) {
            if listDomains[index].id == listID {
                todoThings = listDomains[index].todoThingDomains!
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        var isNewItem = true
        var matchedIndex : Int64 = -1
        var thisTextField = textView as! MyTodoCellTextView
        
        var index : Int64 = 0
        for todoThing in db[GlobalSetting.todoThingTableName] {
            if todoThing[GlobalSetting.TodoThing.id] == thisTextField.id {
                isNewItem = false
                matchedIndex = index
            }
            index++
        }
        
        
        if isNewItem {
            if thisTextField.text.isEmpty {
                self.todoThings.removeAtIndex(0)
                self.myTodoList_tableView.reloadData()
            }
            else {
                db[GlobalSetting.todoThingTableName].insert(
                    GlobalSetting.TodoThing.id <- thisTextField.id,
                    GlobalSetting.TodoThing.listID <- listID,
                    GlobalSetting.TodoThing.thing <- thisTextField.text,
                    GlobalSetting.TodoThing.deadLine <- 1
                )
                loadDataFromDataBase()
                self.myTodoList_tableView.reloadData()
            }
            
        }
        else {
            //database
            let todoThing = db[GlobalSetting.todoThingTableName].filter(GlobalSetting.TodoThing.id == matchedIndex)
            todoThing.update(GlobalSetting.TodoThing.thing <- (textView as! MyTodoCellTextView).text)
            
            //修改domain
            for(var index = 0; index < todoThings.count; index++) {
                if thisTextField.id == todoThings[index].id {
                    todoThings[index].thing = thisTextField.text
                }
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        var range = textView.selectedTextRange
        if textView.selectedRange.location == 0 {
            textView.text = ""
            return
        }

        var typedContent = (textView.text as NSString).substringToIndex(textView.selectedRange.location) as String
        
        for todoThing in db[GlobalSetting.todoThingTableName] {
            
            var string = todoThing[GlobalSetting.TodoThing.thing]
            
            if listID == todoThing[GlobalSetting.TodoThing.listID]
                && startsWith(string, typedContent) == true {
                    textView.text = string
                    var newRange : UITextRange = range?.copy() as! UITextRange
                    textView.selectedTextRange = newRange
                    break
            }
            else {
                textView.text = (textView.text as NSString).substringToIndex(textView.selectedRange.location)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoThings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == 0 {
            emptyCell = nil
        }
        let cell = myTodoList_tableView.dequeueReusableCellWithIdentifier("myTodoCell_identifier") as! MyTodoCell
        cell.todoThingName_myTodoCellTextView.text = todoThings[indexPath.row].thing
        cell.todoThingName_myTodoCellTextView.id = todoThings[indexPath.row].id
        if cell.todoThingName_myTodoCellTextView.text.isEmpty {
            emptyCell = cell
        }
        if indexPath.item == todoThings.count - 1 && emptyCell != nil {
            emptyCell?.todoThingName_myTodoCellTextView.becomeFirstResponder()
        }
        cell.todoThingName_myTodoCellTextView.delegate = self
        
        //background of cell
        var start_red : CGFloat, start_green : CGFloat, start_blue : CGFloat, start_alpha : CGFloat
        var end_red : CGFloat, end_green : CGFloat, end_blue : CGFloat, end_alpha : CGFloat

        let count = todoThings.count > 5 ? todoThings.count : 5
        
        var index = Int(GlobalSetting.currentTheme)
        cell.backgroundColor = UIColor(
            red: (CGFloat)( (themes[index].endColor.getRed() - themes[index].startColor.getRed()) / count * indexPath.item + themes[index].startColor.getRed() ) / 255.0,
            green: (CGFloat)( (themes[index].endColor.getGreen() - themes[index].startColor.getGreen()) / count * indexPath.item + themes[index].startColor.getGreen() ) / 255.0,
            blue: (CGFloat)( (themes[index].endColor.getBlue() - themes[index].startColor.getBlue()) / count * indexPath.item + themes[index].startColor.getBlue() ) / 255.0,
            alpha: 1.0)
        
        themes[index].startColor.getRed()
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteAciont = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: nil, handler: {action, indexpath in
            
            self.db[GlobalSetting.todoThingTableName].filter(GlobalSetting.TodoThing.id == self.todoThings[indexPath.item].id).delete()
            
            self.todoThings.removeAtIndex(indexPath.item)
            self.myTodoList_tableView.reloadData()
        });
        deleteAciont.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        return [deleteAciont];
    }
    
}