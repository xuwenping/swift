//
//  User.swift
//  AutoLayout
//
//  Created by devinxu on 5/19/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let company: String
    let login: String
    let password: String
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password {
                return user
            }
        }
        
        return nil
    }
    
    // computed properties
    // 因为这是一个Dictionary类型，所以后面需要加()
    static let database: Dictionary<String, User> = {
        var theDataBase = Dictionary<String, User>()
        for user in [
            User(name: "Jone Apple", company: "Apple", login: "japple", password: "foo"),
            User(name: "Devin Apple Inc", company: "Rongyi rongyi good company best change to shopping", login: "madum", password: "foo"),
            User(name: "Sam Apple", company: "Baidu", login: "madum2", password: "foo"),
            User(name: "Bit Apple", company: "Alibaba", login: "madum3", password: "foo")
        ]{
            theDataBase[user.login] = user
        }
        return theDataBase
    }()
}