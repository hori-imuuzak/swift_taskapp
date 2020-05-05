//
//  TaskRepository.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

protocol TaskRepository {
    func find(id: Int) -> Task?
    func findAll() -> Array<Task>
    func findByCategory(category: String) -> Array<Task>
    func create(task: Task) -> Bool
    func update(id: Int, task: Task) -> Bool
    func delete(task: Task) -> Bool
}
