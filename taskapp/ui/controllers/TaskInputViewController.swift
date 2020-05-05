//
//  TaskInputViewController.swift
//  taskapp
//
//  Created by 堀知海 on 2020/05/05.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit

enum EditMode {
    case create
    case update
}

class TaskInputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var startAtDatePicker: UIDatePicker!
    
    var taskId: Int? = nil
    var taskService: TaskService!
    var editMode: EditMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.taskService = TaskService(taskRepository: TaskRepositoryImpl())
        self.taskService.fetchAllTaskList()
        
        self.setupUI()
        self.displayTask()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if editMode == .create {
            self.taskService.createTask(
                title: titleTextField.text ?? "",
                content: contentTextView.text ?? "",
                date: startAtDatePicker.date
            )
        } else if editMode == .update {
            self.taskService.updateTask(
                id: self.taskId!,
                title: titleTextField.text ?? "",
                content: contentTextView.text ?? "",
                date: startAtDatePicker.date
            )
        }
        
        super.viewWillDisappear(animated)
    }
    
    func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func displayTask() {
        if self.taskId == nil {
            self.editMode = EditMode.create
        } else {
            self.editMode = EditMode.update
            if let task = self.taskService.fetchTaskById(id: self.taskId!) {
                titleTextField.text = task.title
                contentTextView.text = task.content
                startAtDatePicker.date = task.date
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
