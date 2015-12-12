//
//  DetailViewController.swift
//  ToDo
//
//  Created by devinxu on 5/20/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    
    @IBOutlet weak var todoItem: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    
    var todo: TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoItem.delegate = self
        
        if todo == nil {
            childButton.selected = true
            navigationController?.title = "new add Todo"
        }
        else {
            navigationController?.title = "Edit Todo"
            if todo?.image == "selected-child" {
                childButton.selected = true
            }
            else if todo?.image == "selected-phone" {
                phoneButton.selected = true
            }
            else if todo?.image == "selected-shopping-cart" {
                shoppingButton.selected = true
            }
            else if todo?.image == "selected-travel" {
                travelButton.selected = true
            }
        }
        
        todoItem.text = todo?.title
        //todoDate.setDate((todo?.date)!, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetButtons() {
        childButton.selected = false
        phoneButton.selected = false
        shoppingButton.selected = false
        travelButton.selected = false
    }
    
    @IBAction func childTapped(sender: AnyObject) {
        resetButtons()
        childButton.selected = true
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        resetButtons()
        phoneButton.selected = true
    }
    
    @IBAction func shoppingTapped(sender: AnyObject) {
        resetButtons()
        shoppingButton.selected = true
    }
    
    @IBAction func travelTapped(sender: AnyObject) {
        resetButtons()
        travelButton.selected = true
    }
    
    @IBAction func okTapped(sender: AnyObject) {
        var image = ""
        if childButton.selected {
            image = "selected-child"
        }
        else if phoneButton.selected {
            image = "selected-phone"
        }
        else if shoppingButton.selected {
            image = "selected-shopping-cart"
        }
        else if phoneButton.selected {
            image = "selected-travel"
        }
        
        if todo == nil {
            let uuid = NSUUID.init().UUIDString
            var todo = TodoModel(id: uuid, image: image, title: todoItem.text, date: todoDate.date)
            todos.append(todo)
        }
        else {
            todo?.image = image
            todo?.title = todoItem.text
            todo?.date = todoDate.date
        }
        
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        todoItem.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
