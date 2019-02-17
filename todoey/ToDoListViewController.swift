//
//  ViewController.swift
//  todoey
//
//  Created by Sinan MacBook on 11.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var arrayOfTheList = ["Sinan", "Karaca" , "Otosan"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //TODO: TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell" , for : indexPath)
        
        cell.textLabel?.text = arrayOfTheList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTheList.count
    }
    
    //TODO: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arrayOfTheList[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: New section add / Bar button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            // What will happen when the user click alert button
            
            self.arrayOfTheList.append(textField.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated : true , completion : nil)
    }
}

