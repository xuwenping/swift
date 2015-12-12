//
//  CheckListItem.swift
//  CheckLists
//
//  Created by devinxu on 8/1/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

class CheckListItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    var dueDate = NSDate()
    var shouldReminder = false
    var itemID: Int
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldReminder, forKey: "ShouldReminder")
        aCoder.encodeInteger(itemID, forKey: "ItemId")
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldReminder = aDecoder.decodeBoolForKey("ShouldReminder")
        itemID = aDecoder.decodeIntegerForKey("ItemId")
        
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func scheduleNotification() {
        if shouldReminder && (dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending) {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            println("We should schedule a notification!")
        }
    }
}
