//
//  MyTodoPage.swift
//  MyClear
//
//  Created by boli on 2/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import SQLite

class MyTodoPage: UITableViewController, UITextViewDelegate, TableViewCellDelegate {

    var listID : Int64 = -1;
    var todoThings : [TodoThingDomain] = []
    
    var emptyCell : MyTodoCell?
    
    var thingColorRed : CGFloat = 217;
    var thingColorGreed : CGFloat = 0;
    var thingColorBlue : CGFloat = 22;
    
    var editingCell : MyTodoCell?
    
    //Pinch to add Gesture
    var placeHolderCell : MyTodoCell?
    let pinchToAdd_UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    
    @IBOutlet var myTodoList_tableView: UITableView!
    
    func addHeadView() {
        self.myTodoList_tableView.addHeaderWithCallback { (state : RefreshState) -> Void in
            if RefreshState.back == state {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if RefreshState.addNewItem == state {
                self.addCellAtIndex(0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadData();
        self.addHeadView()
        
        myTodoList_tableView.separatorStyle = .None
        myTodoList_tableView.rowHeight = 70
        
        pinchToAdd_UIPinchGestureRecognizer.addTarget(self, action: "pinchToAddHandler:")
        myTodoList_tableView.addGestureRecognizer(pinchToAdd_UIPinchGestureRecognizer)
    }
    
    func loadData() {
        todoThings.removeAll(keepCapacity: false)
        for(var index = 0; index < listDomains.count; index++) {
            if listDomains[index].id == listID {
                todoThings = listDomains[index].todoThingDomains!
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //对非编辑cell添加透明
        let visibleCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        for cell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                if cell.todoThingName_myTodoCellTextView !== textView as! MyTodoCellTextView {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        //对非编辑cell添加透明
        let visibleCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        for cell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                if cell.todoThingName_myTodoCellTextView !== textView as! MyTodoCellTextView {
                    cell.alpha = 1
                }
            })
        }
        
        var isNewItem = true
        var matchedIndex : Int64 = -1
        let thisTextField = textView as! MyTodoCellTextView
        
        var index : Int64 = 0
        for todoThing in GlobalVariables.db.prepare(GlobalVariables.todoThingTable) {
            if todoThing[GlobalVariables.TodoThing.id] == thisTextField.id {
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
                    try GlobalVariables.db.run(GlobalVariables.todoThingTable.insert(
                        GlobalVariables.TodoThing.id <- thisTextField.id,
                        GlobalVariables.TodoThing.listID <- listID,
                        GlobalVariables.TodoThing.thing <- thisTextField.text,
                        GlobalVariables.TodoThing.deadLine <- 1,
                        GlobalVariables.TodoThing.isComplete <- false))
                }catch let error {
                    print(error)
                }
                loadDataFromDataBase()
                self.loadData()
                self.myTodoList_tableView.reloadData()
            }
            
        }
        else {
            //database
            do {
                try GlobalVariables.db.run(GlobalVariables.todoThingTable.filter(GlobalVariables.TodoThing.id == matchedIndex).update(GlobalVariables.TodoThing.thing <- (textView as! MyTodoCellTextView).text))
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
        
        for todoThing in GlobalVariables.db.prepare(GlobalVariables.todoThingTable) {
            
            let string = todoThing[GlobalVariables.TodoThing.thing]
            
            if listID == todoThing[GlobalVariables.TodoThing.listID]
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
        cell.todoThingName_myTodoCellTextView.id = todoThings[indexPath.row].id
        if cell.todoThingName_myTodoCellTextView.text.isEmpty {
            emptyCell = cell
        }
        cell.todoThingName_myTodoCellTextView.delegate = self
        cell.selectionStyle = .None
        
        //background of cell
        let count = todoThings.count > 5 ? todoThings.count : 5
        
        let index = Int(GlobalVariables.currentTheme)
        cell.backgroundColor = UIColor(
            red: (CGFloat)( (themes[index].endColor.getRed() - themes[index].startColor.getRed()) / count * indexPath.item + themes[index].startColor.getRed() ) / 255.0,
            green: (CGFloat)( (themes[index].endColor.getGreen() - themes[index].startColor.getGreen()) / count * indexPath.item + themes[index].startColor.getGreen() ) / 255.0,
            blue: (CGFloat)( (themes[index].endColor.getBlue() - themes[index].startColor.getBlue()) / count * indexPath.item + themes[index].startColor.getBlue() ) / 255.0,
            alpha: 1.0)
        
        themes[index].startColor.getRed()
        
        //delte 
        cell.delegate = self
        cell.toDoItem = todoThings[indexPath.item]
        if indexPath == 0 {
//            cell.todoThingName_myTodoCellTextView.becomeFirstResponder()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return myTodoList_tableView.rowHeight;
    }
    
    func toDoItemDeleted(toDoItem: TodoThingDomain) {
        let index = (todoThings as NSArray).indexOfObject(toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        do {
            try GlobalVariables.db.run(GlobalVariables.todoThingTable.filter(GlobalVariables.TodoThing.id == self.todoThings[index].id).delete())
        } catch let error {
            print(error)
        }
        todoThings.removeAtIndex(index)
        
        // loop over the visible cells to animate delete
        let visibleCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        let lastView = visibleCells[visibleCells.count - 1] as MyTodoCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseInOut,
                    animations: {() in
                        cell.frame = CGRectOffset(cell.frame, 0.0,
                            -cell.frame.size.height)},
                    completion: {(finished: Bool) in
                        if (cell == lastView) {
                            self.tableView.reloadData()
                        }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.hidden = true
            }
        }
        
        // use the UITableView to animate the removal of this row
        myTodoList_tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        myTodoList_tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        myTodoList_tableView.endUpdates()
    }
    
    // MARK: - pinch-to-add methods
    
    // indicates that the pinch is in progress
    var pinchInProgress = false
    struct PinchToAddTouchPoints {
        var upPoint : CGPoint
        var lowPoint : CGPoint
    }
    var upTableViewCellIndex = -100;
    var lowTableViewCellIndex = -100
    var initialTouchPoints : PinchToAddTouchPoints!
    var pinchExceededRequiredDistance = false
    //添加cell时的上面一个cell
    var precedingCell : MyTodoCell!
    
    func pinchToAddHandler(recognizer : UIPinchGestureRecognizer) {
        if recognizer.state == .Began {
            pinchStarted(recognizer)
        }
        if recognizer.state == .Changed && pinchInProgress && pinchToAdd_UIPinchGestureRecognizer.numberOfTouches() == 2 {
            pinchChanged(recognizer)
        }
        if recognizer.state == .Ended {
            pinchEnded(recognizer)
        }
    }
    
    func pinchStarted(recognizer: UIPinchGestureRecognizer) {
        initialTouchPoints = getNormalizedTouchPoints(recognizer)
        upTableViewCellIndex = -1
        lowTableViewCellIndex = -1
        let myTodoListVisibleCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        for i in 0..<myTodoListVisibleCells.count {
            if isViewContainsPoint(myTodoListVisibleCells[i], point: initialTouchPoints.upPoint) {
                upTableViewCellIndex = i
            }
            if isViewContainsPoint(myTodoListVisibleCells[i], point: initialTouchPoints.lowPoint) {
                lowTableViewCellIndex = i
            }
        }
        if((lowTableViewCellIndex - upTableViewCellIndex) == 1) {
            pinchInProgress = true
            precedingCell = myTodoListVisibleCells[upTableViewCellIndex]
            placeHolderCell = myTodoList_tableView.dequeueReusableCellWithIdentifier("myTodoCell_identifier") as? MyTodoCell
            placeHolderCell!.frame = CGRectOffset(myTodoListVisibleCells[upTableViewCellIndex].frame, 0, myTodoList_tableView.rowHeight / 2)
            placeHolderCell!.backgroundColor = UIColor.redColor()
            myTodoList_tableView.insertSubview(placeHolderCell!, atIndex: 0)
        }
        
    }
    
    func pinchChanged(recognizer: UIPinchGestureRecognizer) {
        let currentTouchPoints = getNormalizedTouchPoints(recognizer)
        let upperDelat = initialTouchPoints.upPoint.y - currentTouchPoints.upPoint.y
        let lowerDelta = currentTouchPoints.lowPoint.y - initialTouchPoints.lowPoint.y
        let delta = max(upperDelat, lowerDelta)
        //移动cells
        let visiableCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        for i in 0..<visiableCells.count {
            if i <= upTableViewCellIndex {
                visiableCells[i].transform = CGAffineTransformMakeTranslation(0, -delta)
            }
            if i >= lowTableViewCellIndex {
                visiableCells[i].transform = CGAffineTransformMakeTranslation(0, delta)
            }
        }
        
        //添加新增cell的动画效果
        let gapSize = delta * 2
        let cappedGapSize = min(gapSize, myTodoList_tableView.rowHeight)
        placeHolderCell?.transform = CGAffineTransformMakeTranslation(1.0, cappedGapSize / myTodoList_tableView.rowHeight)
        placeHolderCell?.todoThingName_myTodoCellTextView.text = cappedGapSize > myTodoList_tableView.rowHeight ? "release to add item" : "pull up to release item"
        placeHolderCell?.alpha = min(1.0, cappedGapSize / myTodoList_tableView.rowHeight)
        pinchExceededRequiredDistance = gapSize > myTodoList_tableView.rowHeight
        placeHolderCell?.backgroundColor = precedingCell.backgroundColor
    }
    
    func pinchEnded(recognizer: UIPinchGestureRecognizer) {
        pinchInProgress = false
        
        placeHolderCell?.transform = CGAffineTransformIdentity
        placeHolderCell?.removeFromSuperview()
        
        if pinchExceededRequiredDistance {
            pinchExceededRequiredDistance = false
            
            let visiableCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
            for i in 0..<visiableCells.count {
                visiableCells[i].transform = CGAffineTransformIdentity
            }
            print(upTableViewCellIndex)
            addCellAtIndex(upTableViewCellIndex + 1)
        }
        else {
            UIView.animateWithDuration(00.2, delay: 0.0, options: .CurveEaseInOut, animations: {
                () in
                let visiableCells = self.myTodoList_tableView.visibleCells as! [MyTodoCell]
                for cell in visiableCells {
                    cell.transform = CGAffineTransformIdentity
                }
                }, completion: nil)
        }
    }
    
    func getNormalizedTouchPoints(recognizer : UIGestureRecognizer) -> PinchToAddTouchPoints {
        var point1 = recognizer.locationOfTouch(0, inView: myTodoList_tableView)
        var point2 = recognizer.locationOfTouch(1, inView: myTodoList_tableView)
        if point1.y > point2.y {
            let temp = point1
            point1 = point2
            point2 = temp
        }
        return PinchToAddTouchPoints(upPoint: point1, lowPoint: point2)
    }
    
    func isViewContainsPoint(view : UIView, point : CGPoint) -> Bool{
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    
    func addCellAtIndex(index : Int) {
        var maxID : Int64 = -1
        let newItem : TodoThingDomain = TodoThingDomain()
        newItem.deadLine = 1
        newItem.listID = self.listID
        newItem.thing = ""
        for(var index = 0; index < self.todoThings.count; index++) {
            maxID = self.todoThings[index].id > maxID ? self.todoThings[index].id : maxID
        }
        newItem.id = maxID + 1
        self.todoThings.insert(newItem, atIndex: index)
        self.myTodoList_tableView.reloadData()
        
        let visiableCells = myTodoList_tableView.visibleCells as! [MyTodoCell]
        for i in 0..<visiableCells.count {
            if visiableCells[i].todoThingName_myTodoCellTextView.id == newItem.id {
                editingCell = visiableCells[i]
                editingCell?.todoThingName_myTodoCellTextView.becomeFirstResponder()
                break
            }
        }
    }
}