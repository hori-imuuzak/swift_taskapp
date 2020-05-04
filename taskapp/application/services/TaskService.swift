//
//  TaskService.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

class TaskService {
    private let taskRepository: TaskRepository
    private var taskList: Array<Task> = []
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func fetchAllTaskList() -> Array<Task> {
        taskList = self.taskRepository.findAll()
        return taskList
    }
    
    func deleteTaskAt(index: Int) -> Bool {
        let task = self.taskList[index]
        return self.taskRepository.delete(task: task)
    }
    
    func getAt(index: Int) -> Task {
        return self.taskList[index]
    }
    
    func getTaskCount() -> Int {
        return taskList.count
    }
}
