//
//  ListDetailViewController.swift
//  CheckLists
//
//  Created by devinxu on 8/16/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    
    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingCheckList checkList: CheckList)
    
    func listDetailviewController(controller: ListDetailViewController,
        didFinishEditingCheckList checkList: CheckList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    var checkListToEdit: CheckList?
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let list = checkListToEdit {
            title = "Edit CheckList"
            
            textField.text = list.name;
            doneBarButton.enabled = true
            iconName = list.iconName
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerViewController
            
            controller.delegate = self
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    @IBAction func cancel() {
//        dismissViewControllerAnimated(true, completion: nil)
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let list = checkListToEdit {
            list.name = textField.text
            list.iconName = iconName
            
            delegate?.listDetailviewController(self, didFinishEditingCheckList: list)
        }
        else {
            let list = CheckList(name: textField.text, iconName: iconName)
            
            delegate?.listDetailViewController(self, didFinishAddingCheckList: list)
        }
    }
    
    func iconPicker(picker: IconPickerViewController, didPickerIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
            
    }
}
