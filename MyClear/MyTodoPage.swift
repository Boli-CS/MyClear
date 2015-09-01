//
//  MyTodoPage.swift
//  MyClear
//
//  Created by boli on 2/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class MyTodoPage: UITableViewController, UITextViewDelegate {

    var listID : Int32?;
    var todoThings : [TodoThingDomain] = []
    
    var emptyCell : MyTodoCell?
    
    var thingColorRed : CGFloat = 217;
    var thingColorGreed : CGFloat = 0;
    var thingColorBlue : CGFloat = 22;
    
    @IBOutlet var myTodoList_tableView: UITableView!
    
    func addHeadView() {
        self.myTodoList_tableView.addHeaderWithCallback { (var state : RefreshState) -> Void in
            if RefreshState.back == state {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if RefreshState.addNewItem == state {
                var maxID : Int32 = -1
                var newItem : TodoThingDomain = TodoThingDomain()
                newItem.deadLine = NSDate()
                newItem.listID = self.listID
                newItem.thing = ""
                for(var index = 0; index < self.todoThings.count; index++) {
                    maxID = self.todoThings[index].id! > maxID ? self.todoThings[index].id! : maxID
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
        var matchedIndex : Int?
        var thisTextField = textView as! MyTodoCellTextView
        
        for(var index = 0; index < todoThings_db.count; index++) {
            if todoThings_db[index].valueForKey("id")?.intValue == thisTextField.id {
                isNewItem = false
                matchedIndex = index
            }
        }
        if isNewItem {
            if thisTextField.text.isEmpty {
                self.todoThings.removeAtIndex(0)
                self.myTodoList_tableView.reloadData()
            }
            else {
                var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                var firstrow : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("TodoThing", inManagedObjectContext: context!)
                firstrow.setValue(NSDate(), forKey: "deadline")
                firstrow.setValue(Int(thisTextField.id!), forKey: "id")
                firstrow.setValue(Int(listID!), forKey: "listid")
                firstrow.setValue(thisTextField.text, forKey: "thing")
                context?.save(nil)
                loadDataFromDataBase()
                self.myTodoList_tableView.reloadData()
            }
            
        }
        else {
            //database
            var data = todoThings_db[matchedIndex!] as! NSManagedObject
            data.setValue((textView as! MyTodoCellTextView).text, forKey: "thing")
            data.managedObjectContext?.save(nil)

            
            //修改domain
            for(var index = 0; index < todoThings.count; index++) {
                if thisTextField.id! == todoThings[index].id {
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
        
        for (var i  = 0; i < todoThings_db.count; i++) {
            
            var string = todoThings_db[i].valueForKey("thing") as? NSString
            
            if listID == todoThings_db[i].valueForKey("listid")?.intValue
                && startsWith(string as! String, typedContent) == true {
                    textView.text = string as! String
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
        var count : CGFloat = CGFloat(todoThings.count)
        var cellIndex : CGFloat = CGFloat(indexPath.item)
        cell.backgroundColor = UIColor(red: (thingColorRed + ((255.0 - thingColorRed) / count) * cellIndex) / 255.0,
            green: cellIndex / count,
            blue: (thingColorBlue + cellIndex) / 255.0, alpha: 1)
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
            var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            for(var index = 0; index < todoThings_db.count; index++) {
                if todoThings_db[index].valueForKey("id")?.intValue == self.todoThings[indexPath.item].id {
                    context?.deleteObject(todoThings_db[index] as! NSManagedObject)
                    context?.save(nil)
                }
            }
            self.todoThings.removeAtIndex(indexPath.item)
            self.myTodoList_tableView.reloadData()
        });
        deleteAciont.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        return [deleteAciont];
    }
    
    
}