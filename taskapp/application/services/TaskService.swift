//
//  TaskService.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation
import UserNotifications

class TaskService {
    private let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func fetchTaskById(id: Int) -> Task? {
        return self.taskRepository.find(id: id)
    }
    
    func fetchAllTaskList() -> Array<Task> {
        return self.taskRepository.findAll()
    }
    
    func fetchFilteredByCategoryTaskList(category: String) -> Array<Task> {
        return self.taskRepository.findByCategory(category: category)
    }
    
    func createTask(title: String, category: String, content: String, date: Date) -> Bool {
        if title.isEmpty {
            return false
        }

        let task = Task()
        task.title = title
        task.category = category
        task.content = content
        task.date = date
        
        let taskList = self.fetchAllTaskList()
        let taskId = ((taskList.max(by: { (a, b) -> Bool in return a.id < b.id }))?.id ?? 0) + 1
        task.id = taskId

        let result = self.taskRepository.create(task: task)
        if result {
            self.fetchAllTaskList()
        }
        
        setTaskNotification(task)
        
        return result
    }
    
    func updateTask(id: Int, title: String, category: String, content: String, date: Date) -> Bool {
        if title.isEmpty {
            return false
        }

        let task = Task()
        task.id = id
        task.title = title
        task.category = category
        task.content = content
        task.date = date

        let result = self.taskRepository.update(id: task.id, task: task)
        
        setTaskNotification(task)
        
        return result
    }
    
    func deleteTask(task: Task) -> Bool {
        let taskId = task.id
        let result = self.taskRepository.delete(task: task)
        
        // 通知の削除
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(taskId)])
        printPendingNotifications(center)
        
        return result
    }
    
    func setTaskNotification(_ task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.content.isEmpty ? "（内容なし）" : task.content
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            print(error ?? "ローカル通知登録OK")
        }
        
        printPendingNotifications(center)
    }
    
    private func printPendingNotifications(_ center: UNUserNotificationCenter) {
        center.getPendingNotificationRequests { requests in
            for request in requests {
                print("/-------------------/")
                print(request)
                print("/-------------------/")
            }
        }
    }
}
