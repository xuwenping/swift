//
//  CheckList.swift
//  CheckLists
//
//  Created by devinxu on 8/11/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit

class CheckList: NSObject, NSCoding {
    var name = ""
    var items = [CheckListItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Item")
    }

    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [CheckListItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count++
            }
        }
        
        return count
    }
}
