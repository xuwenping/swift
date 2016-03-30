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
            
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
        }
    }
    
    var happiness: Int = 25 { // 0 = very sad, 100 = very happy
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    func updateUI() {
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
    private struct Constant {
        static let HappinessGestureScale: CGFloat = 4
    }
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constant.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
            
        default:
            break
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50)/50
    }
}
