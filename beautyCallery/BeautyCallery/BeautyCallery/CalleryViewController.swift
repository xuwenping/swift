//
//  CalleryViewController.swift
//  BeautyCallery
//
//  Created by devinxu on 15/5/17.
//  Copyright (c) 2015年 devinxu. All rights reserved.
//

import UIKit
import Social

class CalleryViewController: UIViewController {
    
    var imageName: String?
    
    @IBOutlet weak var beautyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let name = imageName {
            beautyImage.image = UIImage(named: name)
            
            switch name {
            case "fanbingbing":
                navigationItem.title = "范冰冰"
            case "libingbing":
                navigationItem.title = "李冰冰"
            case "wangfei":
                navigationItem.title = "王菲"
            case "yangmi":
                navigationItem.title = "杨幂"
            case "zhouxun":
                navigationItem.title = "周迅"
            default:
                navigationItem.title = "女神画廊"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func shareTapped(sender: AnyObject) {
        var controller: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        controller.setInitialText("一起来玩女神画廊app吧，就在Github上")
        controller.addImage(beautyImage.image)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
