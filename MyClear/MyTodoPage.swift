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
    let db = try! Connection(GlobalSetting.dbPath);
    
    @IBOutlet var myTodoList_tableView: UITableView!
    
    func addHeadView() {
        self.myTodoList_tableView.addHeaderWithCallback { (state : RefreshState) -> Void in
            if RefreshState.back == state {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if RefreshState.addNewItem == state {
                var maxID : Int64 = -1
                let newItem : TodoThingDomain = TodoThingDomain()
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
        let thisTextField = textView as! MyTodoCellTextView
        
        var index : Int64 = 0
        for todoThing in db.prepare(GlobalSetting.todoThingTable) {
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
                do {
                    try db.run(GlobalSetting.todoThingTable.insert(
                        GlobalSetting.TodoThing.id <- thisTextField.id,
                        GlobalSetting.TodoThing.listID <- listID,
                        GlobalSetting.TodoThing.thing <- thisTextField.text,
                        GlobalSetting.TodoThing.deadLine <- 1))
                }catch let error {
                    print(error)
                }
                loadDataFromDataBase()
                self.myTodoList_tableView.reloadData()
            }
            
        }
        else {
            //database
            do {
                try db.run(GlobalSetting.todoThingTable.filter(GlobalSetting.TodoThing.id == matchedIndex).update(GlobalSetting.TodoThing.thing <- (textView as! MyTodoCellTextView).text))
            }catch let error {
                print(error)
            }
            
            //修改domain
            for(var index = 0; index < todoThings.count; index++) {
                if thisTextField.id == todoThings[index].id {
                    todoThings[index].thing = thisTextField.text
                }
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let range = textView.selectedTextRange
        if textView.selectedRange.location == 0 {
            textView.text = ""
            return
        }

        let typedContent = (textView.text as NSString).substringToIndex(textView.selectedRange.location) as String
        
        for todoThing in db.prepare(GlobalSetting.todoThingTable) {
            
            let string = todoThing[GlobalSetting.TodoThing.thing]
            
            if listID == todoThing[GlobalSetting.TodoThing.listID]
                && string.characters.startsWith(typedContent.characters) == true {
                    textView.text = string
                    let newRange : UITextRange = range?.copy() as! UITextRange
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
        let count = todoThings.count > 5 ? todoThings.count : 5
        
        let index = Int(GlobalSetting.currentTheme)
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
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAciont = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: nil, handler: {action, indexpath in
            do {
                try self.db.run(GlobalSetting.todoThingTable.filter(GlobalSetting.TodoThing.id == self.todoThings[indexPath.item].id).delete())
            } catch let error {
                print(error)
            }
            
            self.todoThings.removeAtIndex(indexPath.item)
            self.myTodoList_tableView.reloadData()
        });
        deleteAciont.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        return [deleteAciont];
    }
    
}