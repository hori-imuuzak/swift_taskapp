//
//  TaskRepositoryImpl.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import RealmSwift

class TaskRepositoryImpl: TaskRepository {
    private let realm: Realm!

    init() {
        self.realm = try! Realm()
    }
    
    func findAll() -> Array<Task> {
        return Array(self.realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true))
    }
    
    func delete(task: Task) -> Bool {
        do {
            self.realm.delete(task)
            return true
        } catch {
            return false
        }
    }
}
