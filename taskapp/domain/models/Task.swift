//
//  Task.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var content = ""
    
    @objc dynamic var date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
