//
//  TwitterDetailTableViewController.swift
//  Smashtag
//
//  Created by devinxu on 6/19/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class TwitterDetailTableViewController: UITableViewController {
    enum Mention {
        case MentionUrl(String)
        case MentionHashtag(String)
        case MentionUser(String)
        case MentionImage(MediaItem)
        
        var description: String {
            switch self {
            case .MentionUrl(let url):
                return url
            case .MentionHashtag(let hashtag):
                return hashtag
            case .MentionUser(let user):
                return user
            case .MentionImage(let mediaItem):
                return mediaItem.url.absoluteString
            }
        }
        
        var type: String {
            switch self {
            case .MentionUrl(_):
                return "Urls"
            case .MentionHashtag(_):
                return "Hashtags"
            case .MentionUser(_):
                return "Users"
            case .MentionImage(_):
                return "Images"
            }
        }
    }
    
    private var mentions = [[Mention]]()
    private func addMentions(mentionsToAppend: [Mention]) {
        mentions.append(mentionsToAppend)
    }
    
    private struct Storyboard {
        static let ImageCellIdentifier = "Image Cell"
        static let TextCellIdentifier  = "Text Cell"
        static let TwitterSearchSegue  = "Twitter Search"
        static let ShowImageSegue      = "Show Image"
    }
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                title = tweet.user.name
                
                // url
                if tweet.urls.count > 0 {
                    var urls = [Mention]()
                    for url in tweet.urls {
                        urls.append(Mention.MentionUrl(url.keyword))
                    }
                    addMentions(urls)
                }
                
                // hastag
                if tweet.hashtags.count > 0 {
                    var hashtags = [Mention]()
                    for hashtag in tweet.hashtags {
                        hashtags.append(Mention.MentionHashtag(hashtag.keyword))
                    }
                    addMentions(hashtags)
                }
                
                // user
                var userMentions = [Mention]()
                userMentions.append(Mention.MentionUser("@\(tweet.user.screenName)"))
                if tweet.userMentions.count > 0 {
                    for userMention in tweet.userMentions {
                        userMentions.append(Mention.MentionUser(userMention.keyword))
                    }
                }
                addMentions(userMentions)
                
                // image
                if tweet.media.count > 0 {
                    var medias = [Mention]()
                    for media in tweet.media {
                        medias.append(Mention.MentionImage(media))
                    }
                    
                    addMentions(medias)
                }
            }
        }
    }
    
    private struct Constants {
        static let GoldenRatio = (1 + sqrt(5.0))/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section][indexPath.row]
        switch mention {
        case .MentionImage(_):
            return view.bounds.width / CGFloat(Constants.GoldenRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK - data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].first!.type
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section][indexPath.row]
        switch mention {
        case .MentionImage(let mentionItem):
            let cell =
                tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath) as! TwitterDetailImageTableViewCell
            cell.mediaItem = mentionItem
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = mention.description
            return cell
        }
    }
    
    // MARK - data source
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return tw
//    }
}
