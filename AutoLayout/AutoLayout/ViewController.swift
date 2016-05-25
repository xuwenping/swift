//
//  ViewController.swift
//  AutoLayout
//
//  Created by devinxu on 5/12/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var loginInUser: User? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var secure: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secure Password" : "Password"
        nameLabel.text = loginInUser?.name
        companyLabel.text = loginInUser?.company
        image = loginInUser?.image
    }
    
    @IBAction func changeSecurity(sender: AnyObject) {
        secure = !secure
    }
    
    @IBAction func login() {
        loginInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let constraintView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constraintView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constraintView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)

                }
                else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }
    
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet {
            if let newConstraint = aspectRatioConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        }
        else {
            return UIImage(named: "unknow")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? (size.width / size.height) : 0
    }
}

