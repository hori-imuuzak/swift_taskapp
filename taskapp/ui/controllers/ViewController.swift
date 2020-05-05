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
    @IBOutlet weak var filterCategoryTextField: UITextField!
    var taskService: TaskService!
    var taskList: Array<Task> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        self.taskService = TaskService(taskRepository: TaskRepositoryImpl())
        self.taskList = self.taskService.fetchAllTaskList()
    }

    func setupUI() {
        self.taskListTableView?.delegate = self
        self.taskListTableView?.dataSource = self
        
        self.filterCategoryTextField.addTarget(self, action: #selector(ViewController.filterCategoryDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.taskList = self.taskService.fetchAllTaskList()
        self.taskListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskSelectedSegue" {
            let vc = segue.destination as? TaskInputViewController
            if let selectedRow = self.taskListTableView.indexPathForSelectedRow?.row {
                vc?.taskId = self.taskList[selectedRow].id
            }
        }
    }
    
    @objc func filterCategoryDidChange(_ textField: UITextField) {
        if (filterCategoryTextField.text ?? "").isEmpty {
            self.taskList = self.taskService.fetchAllTaskList()
        } else {
            self.taskList = self.taskService.fetchFilteredByCategoryTaskList(category: filterCategoryTextField.text ?? "")
        }
        self.taskListTableView.reloadData()
    }

    // セル数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    // 各セルの内容を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = self.taskList[indexPath.row]
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
            if self.taskService.deleteTask(task: self.taskList[indexPath.row]) {
                self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

