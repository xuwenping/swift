//
//  HudView.swift
//  MyLocations
//
//  Created by devinxu on 2/18/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class HudView: UIView {
    var text = ""
    
    class func hudInView(view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.opaque = false
        
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        
        //hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        hudView.showAnimated(animated)
        
        return hudView
    }
    
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeigth: CGFloat = 96
        
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth)/2),
            y: round((bounds.size.height - boxHeigth)/2),
            width: boxWidth,
            height: boxHeigth
        )
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width/2),
                y: center.y - round(image.size.height/2) - boxHeigth / 8
            )
            
            image.drawAtPoint(imagePoint)
        }
        
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16.0),
                        NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let textSize = text.sizeWithAttributes(attribs)
        
        let textPoint = CGPoint(
            x: center.x - round(textSize.width/2),
            y: center.y - round(textSize.height/2) + boxHeigth/4
        )
        
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }
    
    func showAnimated(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
            })
//            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7,
//                initialSpringVelocity: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft,
//                animations: {
//                    self.alpha = 1
//                    self.transform = CGAffineTransformIdentity
//                },
//                completion: nil)
        }
    }

}
