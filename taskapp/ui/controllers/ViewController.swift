//
//  ViewController.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskListTableView: UITableView!
    var taskService: TaskService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTaskListTableView()
        
        self.taskService = TaskService(taskRepository: TaskRepositoryImpl())
        self.taskService.fetchAllTaskList()
    }

    func setupTaskListTableView() {
        self.taskListTableView?.delegate = self
        self.taskListTableView?.dataSource = self
    }

    // セル数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskService.getTaskCount()
    }
    
    // 各セルの内容を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = self.taskService.getAt(index: indexPath.row)
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskSelectedSegue", sender: nil)
    }
    
    // セル削除可能を伝える
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 削除ボタンが押された時
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.taskService.deleteTaskAt(index: indexPath.row) {
                self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

