//
//  HappinessViewController.swift
//  Happiness
//
//  Created by devinxu on 3/12/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            let recognizer = UIPinchGestureRecognizer(target: faceView, action: "scale:")
            faceView.addGestureRecognizer(recognizer)
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return 0.7
    }
}
