//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by devinxu on 8/1/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(contorller: ItemDetailViewController)
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textFiled: UITextField!
    
    @IBOutlet weak var shouldReminderSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: CheckListItem?
    
    var dueDate = NSDate()
    
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            
            textFiled.text = item.text
            doneBarButton.enabled = true
            shouldReminderSwitch.on = item.shouldReminder
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textFiled.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textFiled.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    @IBAction func cancel() {
//        dismissViewControllerAnimated(true, completion: nil)
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textFiled.text
            item.shouldReminder = shouldReminderSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }
        else {
            let item = CheckListItem()
            item.text = textFiled.text
            item.checked = false
            
            item.shouldReminder = shouldReminderSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
            datePicker.setDate(dueDate, animated: false)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
            
            return cell
        }
        else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        textFiled.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            }
            else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathPicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPathRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathPicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    @IBAction func shouldReminderToggled(switchControl: UISwitch) {
        textFiled.resignFirstResponder()
        
        if switchControl.on {
            let notificationSettings = UIUserNotificationSettings(
                                    forTypes: .Alert | .Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
}
