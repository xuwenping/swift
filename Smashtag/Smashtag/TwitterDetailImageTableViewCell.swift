//
//  TwitterDetailImageTableViewCell.swift
//  Smashtag
//
//  Created by devinxu on 6/19/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class TwitterDetailImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var mediaItem: MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    private var mentionImage: UIImage? {
        didSet {
            detailImageView.image = mentionImage
            activityIndicatorView?.stopAnimating()
        }
    }
    
    func updateUI() {
        detailImageView?.image = nil
        
        if let mediaItem = mediaItem {
            activityIndicatorView?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue) { () -> Void in
                if let imageData = NSData(contentsOfURL: mediaItem.url) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if mediaItem.url == self.mediaItem?.url {
                            self.mentionImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        
    }
}
