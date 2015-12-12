//
//  ViewController.swift
//  CheckLists
//
//  Created by devinxu on 7/28/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate{
    
    // This declares that items will hold an array of CheckListItem objects
    // but it does not actually create that array.
    // At this point, items does not have a value yet.
    //var items: [CheckListItem] // [CheckListItem] is a data type of array
    var checkList: CheckList!
    
//    required init(coder aDecoder: NSCoder) {
//        // This instantiates the array. Now items contains a valid arrray object,
//        // but the array has no CheckListItem objects inside it ye
//        checkList.items = [CheckListItem]()
//        
//        super.init(coder: aDecoder)
//        loadCheckListItems()
//        
//        println("Documents folder is \(documentsDirectory())")
//        println("Data file path is \(dataFilePath())")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 44
        title = checkList.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return checkList.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem") as! UITableViewCell
        
        let item = checkList.items[indexPath.row]
        
        configureTextForCell(cell, withCheckListItem: item)
        
        configureCheckmarkForCell(cell, withCheckListItem: item)
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let item = checkList.items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withCheckListItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
//        saveCheckListItem()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        checkList.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
//        saveCheckListItem()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let contorller = navigationController.topViewController as! ItemDetailViewController
            
            contorller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let contorller = navigationController.topViewController as! ItemDetailViewController
            
            contorller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                contorller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }
    
    func itemDetailViewControllerDidCancel(contorller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        let newRowIndex = checkList.items.count
        checkList.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        
//        saveCheckListItem()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        if let index = find(checkList.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withCheckListItem: item)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
//        saveCheckListItem()
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withCheckListItem item: CheckListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        }
        else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
    }
    
    func configureTextForCell(cell: UITableViewCell, withCheckListItem item: CheckListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = item.text
        
        label.text = "\(item.itemID): \(item.text)"
    }
}

