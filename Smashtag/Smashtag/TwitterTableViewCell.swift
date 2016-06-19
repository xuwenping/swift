//
//  TwitterTableViewCell.swift
//  Smashtag
//
//  Created by devinxu on 6/10/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tweetProfileImageView?.image = nil
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.attributedText = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            let attributeString = NSMutableAttributedString(string: tweet.text)
            
            // 设置hashtag为红色
            for i in tweet.hashtags {
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: i.nsrange)
            }
            
            // 设置usl为黄色
            for i in tweet.urls {
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: i.nsrange)
            }
            
            // 设置user screen name为绿色
            for i in tweet.userMentions {
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: i.nsrange)
            }
            
            tweetTextLabel?.attributedText = attributeString
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
//                if let imageData = NSData(contentsOfURL: profileImageURL) {
//                    tweetProfileImageView?.image = UIImage(data: imageData)
//                }
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if profileImageURL == self.tweet!.user.profileImageURL {
                            if nil != imageData {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }else{
                                self.tweetProfileImageView?.image = nil
                            }
                        }
                    }
                }
            }
        }
    }
}
