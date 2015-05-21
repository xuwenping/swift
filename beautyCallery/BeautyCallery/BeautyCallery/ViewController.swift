//
//  ViewController.swift
//  BeautyCallery
//
//  Created by devinxu on 15/5/16.
//  Copyright (c) 2015年 devinxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var beautyPicker: UIPickerView!
    
    let beauties = ["范冰冰", "李冰冰", "王菲", "杨幂", "周迅"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 这样写是为了告诉编译器，这2个方法要使用本类重载的
        beautyPicker.dataSource = self
        beautyPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToCallery" {
            let index = beautyPicker.selectedRowInComponent(0)
            
            var imageName: String?
            switch index {
            case 0:
                imageName = "fanbingbing"
            case 1:
                imageName = "libingbing"
            case 2:
                imageName = "wangfei"
            case 3:
                imageName = "yangmi"
            case 4:
                imageName = "zhouxun"
            default:
                imageName = nil
                
            }
            
            var vc = segue.destinationViewController as! CalleryViewController
            vc.imageName = imageName
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        print("close")
    }
}

