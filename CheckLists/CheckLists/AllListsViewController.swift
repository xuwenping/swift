//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by devinxu on 8/9/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    var dataModel: DataModel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedCheckList
        
        if (index >= 0) && (index < dataModel.lists.count) {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowCheckLists", sender: checklist)
        }
    }
    
    // will call before animation start
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataModel.lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        let testRow = indexPath.row
        let checkList = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checkList.name
        cell.accessoryType = .DetailDisclosureButton
        
        let count = checkList.countUncheckedItems()
        if checkList.items.count == 0 {
            cell.detailTextLabel!.text = "(NO Item)"
        }
        else if count == 0 {
            cell.detailTextLabel!.text = "All Done"
        }
        else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: checkList.iconName)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "CheckListIndex")
        dataModel.indexOfSelectedCheckList = indexPath.row
        
        let checkList = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowCheckLists", sender: checkList)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCheckLists" {
            let controller = segue.destinationViewController as! CheckListViewController
            controller.checkList = sender as! CheckList
        }
        else if segue.identifier == "AddCheckList" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checkListToEdit = nil
        }
    }
    
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController,didFinishAddingCheckList checkList: CheckList) {
        //let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checkList)
        dataModel.sortCheckList()
        //let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        //let indexPaths = [indexPath]
        //tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailviewController(controller: ListDetailViewController,didFinishEditingCheckList checkList: CheckList) {
//        if let index = find(dataModel.lists, checkList) {
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//                cell.textLabel!.text = checkList.name
//            }
//        }
        dataModel.sortCheckList()
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        
        let checkList = dataModel.lists[indexPath.row]
        
        controller.checkListToEdit = checkList
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController,
        willShowViewController viewController: UIViewController,
        animated: Bool) {
        //This method is called whenever the navigation controller will slider to a new screen
            
        if viewController === self {
            //With === you’re checking whether two variables refer to the exact same object.
            
            //NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "CheckListIndex")
            dataModel.indexOfSelectedCheckList = -1
        }
    }
}
