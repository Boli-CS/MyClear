//
//  MyListPage.swift
//  MyClear
//
//  Created by boli on 1/21/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


var listDomains : [ListDomain]! = []

class MyListPage: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var myListPage_tableView: UITableView!
    
    var listColorRed : CGFloat = 17.0;
    var listColorGreen : CGFloat = 126.0;
    var listColorBlue : CGFloat = 250.0;
    
    var emptyCell : MyListCell?
    var edittingTextField : myListCell_textField?
    
    //上滑操作跳转到对应的view
    var jumpViewId : Int = 0
    
    func loadSound(filename:NSString) -> AVAudioPlayer {
        var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "caf")!)
        println(url)
        var error:NSError? = nil
        let player = AVAudioPlayer(contentsOfURL: url, error: &error)
        player.prepareToPlay()
        return player
    }
    
    var player_1:AVAudioPlayer? = nil

    func addHeaderView() {
        self.tableView.addHeaderWithCallback { (var state : RefreshState) -> Void in
            if state == RefreshState.back {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if state == RefreshState.addNewItem {
                var maxID : Int32 = -1;
                for(var index = 0; index < listDomains.count; index++) {
                    maxID = listDomains[index].id > maxID ? listDomains[index].id! : maxID
                }
                var listDomain : ListDomain = ListDomain()
                //空list添加id为0
                listDomain.id = maxID + 1
                listDomain.listName = ""
                listDomain.todoThingDomains = []
                listDomains.insert(listDomain, atIndex: 0)
                println(listDomains.count)
                self.myListPage_tableView.reloadData()
                
            }
        }
    }
    
    func addFootView() {
        self.tableView.addFooterWithCallback { () -> Void in
            if listDomains.count > 0 && self.jumpViewId >= 0 {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                var vc  = mainStoryboard.instantiateViewControllerWithIdentifier("mytodopage") as! MyTodoPage
                vc.listID = Int32(self.jumpViewId)
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func myListCell_textField_editingDidEnd(sender: AnyObject) {
        var thisTextField = sender as! myListCell_textField
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
                var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                var firstrow : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context!)
                firstrow.setValue(Int(thisTextField.id!), forKey: "id")
                firstrow.setValue(thisTextField.text, forKey: "listname")
                context?.save(nil)

                loadDataFromDataBase()
            }
        }
        else {
            //修改数据库入库
            var data = lists_db[matchedIndex] as! NSManagedObject
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
        self.addFootView()
        self.player_1 = self.loadSound("Scifi-Archive")

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
        if indexPath == 0 {
            emptyCell = nil
        }
        let cell = myListPage_tableView.dequeueReusableCellWithIdentifier("mylistcell_identifier") as! MyListCell
        cell.listName_myListCell_textField.text = listDomains[indexPath.row].listName
        if let var count : Int = listDomains[indexPath.row].todoThingDomains?.count {
            cell.listCount_label.text = "\(count)"
        }
        cell.listName_myListCell_textField.id = listDomains[indexPath.row].id
        if cell.listName_myListCell_textField.text.isEmpty {
            emptyCell = cell
        }
        if indexPath.item == listDomains.count - 1 && emptyCell != nil {
            emptyCell?.listName_myListCell_textField.becomeFirstResponder()
        }
        var count : CGFloat = CGFloat(listDomains.count)
        var cellIndex : CGFloat = CGFloat(indexPath.item)
        
        //background color of cell
        cell.backgroundColor = UIColor(
            red: (listColorRed - (listColorRed / count) * cellIndex) / 255.0,
            green: (listColorGreen + ((255 - listColorGreen) / count) * cellIndex) / 255.0,
            blue: (listColorBlue + ((255 - listColorBlue) / count) * cellIndex) / 255.0,
            alpha: 1)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc  = mainStoryboard.instantiateViewControllerWithIdentifier("mytodopage") as! MyTodoPage
        vc.listID = listDomains[indexPath.row].id
        self.jumpViewId = Int(listDomains[indexPath.row].id!)
        self.presentViewController(vc, animated: true, completion: nil)
        self.player_1?.play()

    }
    
    override func viewDidAppear(animated: Bool) {
        loadDataFromDataBase()
        self.myListPage_tableView.reloadData()
    }
    
    //delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
//        
//            //delete data from database
//            for(var index = 0; index < lists_db.count; index++) {
//                if listDomains[indexPath.item].id == lists_db[index].valueForKey("id")?.intValue {
//                    context?.deleteObject(lists_db[index] as NSManagedObject)
//                    context?.save(nil)
//                }
//            }
//            for(var index = 0; index < todoThings_db.count; index++) {
//                if listDomains[indexPath.item].id == todoThings_db[index].valueForKey("listid")?.intValue {
//                    context?.deleteObject(todoThings_db[index] as NSManagedObject)
//                    context?.save(nil)
//                }
//            }
//        
//            listDomains.removeAtIndex(indexPath.item)
//        }
//        self.myListPage_tableView.reloadData()
    }
    
    @IBAction func myListCell_textField_editingDidBegin(sender: AnyObject) {
        edittingTextField = sender as! myListCell_textField
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: nil, handler:{action, indexpath in
            var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            //delete data from database
            for(var index = 0; index < lists_db.count; index++) {
                if listDomains[indexPath.item].id == lists_db[index].valueForKey("id")?.intValue {
                    context?.deleteObject(lists_db[index] as! NSManagedObject)
                    context?.save(nil)
                }
            }
            for(var index = 0; index < todoThings_db.count; index++) {
                if listDomains[indexPath.item].id == todoThings_db[index].valueForKey("listid")?.intValue {
                    context?.deleteObject(todoThings_db[index] as! NSManagedObject)
                    context?.save(nil)
                }
            }
            
            listDomains.removeAtIndex(indexPath.item)
            self.myListPage_tableView.reloadData()
        });
        
        deleteRowAction.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        return [deleteRowAction];
    }
}