//
//  ViewController.swift
//  loveFinder
//
//  Created by devinxu on 15/5/15.
//  Copyright (c) 2015年 devinxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var birthday: UIDatePicker!
    
    @IBOutlet weak var heightNumber: UISlider!
    
    
    @IBOutlet weak var height: UISlider!
    
    @IBOutlet weak var height1: UILabel!
    
    @IBOutlet weak var hasProperty: UISwitch!
    
    @IBOutlet weak var result: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        name.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func heightChanged(sender: AnyObject) {
        var slider = sender as! UISlider
        var i = Int(heightNumber.value)
        slider.value = Float(i)
        height1.text = "\(i)cm"
        println(height1.text)
    }
    
    @IBAction func okTapped(sender: AnyObject) {
        let genderText = gender.selectedSegmentIndex == 0 ? "高富帅" : "白富美"
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let now = NSDate()
        
        let components = gregorian?.components(NSCalendarUnit.YearCalendarUnit, fromDate: birthday.date, toDate: now, options: NSCalendarOptions(0))
        
        let age = components?.year
        
        let hasPropertyText = hasProperty.on ? "有房" : "没房"
        
        result.text = "\(name.text), \(age!)岁, \(genderText), 身高\(height1.text!), \(hasPropertyText), 求交往！"
    }
    
    // UITextFiledDeleate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

