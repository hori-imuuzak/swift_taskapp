//
//  TaskRepository.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

protocol TaskRepository {
    func findAll() -> Array<Task>
    func delete(task: Task) -> Bool
}
