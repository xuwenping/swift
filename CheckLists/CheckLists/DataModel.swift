//
//  DataModel.swift
//  CheckLists
//
//  Created by devinxu on 8/23/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [CheckList]()
    
    var indexOfSelectedCheckList: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "CheckListIndex")
        }
    }
    
    init() {
        loadCheckLists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        //println("the path is: \(paths[0])")
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveCheckLists() {
        // construct a object to store data
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadCheckLists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [CheckList]
                unarchiver.finishDecoding()
                sortCheckList()
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = ["CheckListIndex": -1,
                          "FirstTime": true,
                          "ChecklistItemID": 0]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = CheckList(name: "List")
            lists.append(checklist)
            indexOfSelectedCheckList = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }
    
    func sortCheckList() {
        lists.sort({ checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) ==
                    NSComparisonResult.OrderedAscending})
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
}
