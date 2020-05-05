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
    
    func find(id: Int) -> Task? {
        return self.realm.objects(Task.self).filter("id = %@", id).first
    }
    
    func findAll() -> Array<Task> {
        return Array(self.realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true))
    }
    
    func create(task: Task) -> Bool {
        do {
            try self.realm.write {
                self.realm.add(task)
            }
            return true
        } catch {
            return false
        }
    }
    
    func update(id: Int, task: Task) -> Bool {
        do {
            task.id = id
            try self.realm.write {
                self.realm.add(task, update: .modified)
            }
            return true
        } catch {
            return false
        }
    }
    
    func delete(task: Task) -> Bool {
        do {
            try self.realm.write {
                self.realm.delete(task)
            }
            return true
        } catch {
            return false
        }
    }
}
