//
//  TaskService.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation

class TaskService {
    private let taskRepository: TaskRepository
    private var taskList: Array<Task> = []
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func fetchTaskById(id: Int) -> Task? {
        return self.taskRepository.find(id: id)
    }
    
    func fetchAllTaskList() -> Array<Task> {
        taskList = self.taskRepository.findAll()
        return taskList
    }
    
    func createTask(title: String, content: String, date: Date) -> Bool {
        if title.isEmpty {
            return false
        }

        let task = Task()
        task.title = title
        task.content = content
        task.date = date

        let taskId = (self.taskList.last?.id ?? 0) + 1
        task.id = taskId

        let result = self.taskRepository.create(task: task)
        if result {
            self.fetchAllTaskList()
        }
        
        return result
    }
    
    func updateTask(id: Int, title: String, content: String, date: Date) -> Bool {
        if title.isEmpty {
            return false
        }

        let task = Task()
        task.id = id
        task.title = title
        task.content = content
        task.date = date

        let result = self.taskRepository.update(id: task.id, task: task)
        if result {
            self.fetchAllTaskList()
        }
        
        return result
    }
    
    func deleteTaskAt(index: Int) -> Bool {
        let task = self.taskList[index]
        let result = self.taskRepository.delete(task: task)
        if result {
            self.fetchAllTaskList()
        }
        
        return result
    }
    
    func getAt(index: Int) -> Task {
        return self.taskList[index]
    }
    
    func getTaskCount() -> Int {
        return taskList.count
    }
}
