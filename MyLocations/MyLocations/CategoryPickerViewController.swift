//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by devinxu on 2/9/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

protocol CategoryPickerViewControllerDelegate: class {
    func categoryPickerViewController(controller: CategoryPickerViewController, didSelectedCategory cell: String)
}


import UIKit

class CategoryPickerViewController: UITableViewController {
    
    var delegate: CategoryPickerViewControllerDelegate?
    
    var selectedCategoryName = "No Category"
    
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    var selectedIndexPath = NSIndexPath()
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView,
            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let categroyName = categories[indexPath.row]
        cell.textLabel!.text = categroyName
        
        if categroyName == selectedCategoryName {
            cell.accessoryType = .Checkmark
            selectedIndexPath = indexPath
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRowAtIndexPath(indexPath) {
                newCell.accessoryType = .Checkmark
            }
        
            if let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath) {
                oldCell.accessoryType = .None
            }
        
            selectedIndexPath = indexPath
            
            if let delegate = self.delegate {
                delegate.categoryPickerViewController(self, didSelectedCategory: categories[indexPath.row])
            }
        }
    }
}

