//
//  ImageViewContorller.swift
//  Cacini
//
//  Created by devinxu on 5/25/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class ImageViewContorller: UIViewController, UIScrollViewDelegate {
    var imageURL: NSURL? {
        didSet {
            if nil != view.window {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            // start multi thread
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                // because image assginment is UI operation, so need dispatch back  to main thread
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if url == self.imageURL {
                        if nil != imageData {
                            self.image = UIImage(data: imageData!)
                        }else{
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    private var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        //imageURL = NSURL(string: "http://stanford.edu/about/images/intro_about.jpg")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if nil == image {
            fetchImage()
        }
    }
}
