//
//  HappinessViewController.swift
//  Happiness
//
//  Created by devinxu on 3/12/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, scaleDataSource {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.delegate = self
        }
    }
    
    func getScaleDataSouce(sender: FaceView) -> CGFloat? {
        return CGFloat(0.8)
    }
}
