//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by devinxu on 1/29/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

//protocol CategoryPickerViewControllerDelegate: class {
//    func categoryPickerViewController(controller: CategoryPickerViewController,
//                                      didSelectedCategory cell: String)
//}

class CategoryPickerViewController: UITableViewController {
    
//    weak var delegate: CategoryPickerViewControllerDelegate?
    
    var selectedCategoryName = ""
    
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Buliding",
        "House",
        "Icecream Vendor",
        "Landmark",
        "park"
    ]
    
    var selectedIndexPath = NSIndexPath()
    
    // MARK: -  UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func  tableView(tableView: UITableView,
                                cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .Checkmark
            selectedIndexPath = indexPath
        }
        else
        {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // MARK - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRowAtIndexPath(indexPath) {
                newCell.accessoryType = .Checkmark
            }
            
            if let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath) {
                oldCell.accessoryType = .None
            }
            
            selectedIndexPath = indexPath
            //selectedCategoryName = categories[indexPath.row]
            
//            delegate?.categoryPickerViewController(self, didSelectedCategory: categories[indexPath.row])
        }
    }
    
    // MARK - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                selectedCategoryName = categories[indexPath.row]
            }
        }
    }
}
