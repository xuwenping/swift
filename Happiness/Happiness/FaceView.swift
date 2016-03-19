//
//  FaceView.swift
//  Happiness
//
//  Created by devinxu on 3/12/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

protocol scaleDataSource: class {
    func getScaleDataSouce(sender: FaceView) -> CGFloat?
}

@IBDesignable
class FaceView: UIView {
    weak var delegate: scaleDataSource?
    
    var lineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blueColor()
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var scale: CGFloat = 0.95 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * delegate!.getScaleDataSouce(self)!
    }
    
    
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        
        facePath.fill()
    }


}
