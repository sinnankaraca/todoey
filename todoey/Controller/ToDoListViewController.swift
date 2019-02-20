//
//  ViewController.swift
//  todoey
//
//  Created by Sinan MacBook on 11.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var arrayOfTheList = [Item]()
    //let defaults  = UserDefaults.standard
    
    let directoryEncoder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(directoryEncoder)
        
        loadData()
        
//        let item1 = Item()
//        item1.title = "Sinan"
//        item1.done = true
//        arrayOfTheList.append(item1)
//
//        let item2 = Item()
//        item2.title = "Karaca"
//        arrayOfTheList.append(item2)
//
//        let item3 = Item()
//        item3.title = "Otosan"
        
//        if let itemArray = defaults.array(forKey: "toDoListDefaults") as? [Item] {
//
//            arrayOfTheList = itemArray
//
//        }
        
        
        
    }
    
    //TODO: TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell" , for : indexPath)
        
        cell.textLabel?.text = arrayOfTheList[indexPath.row].title
        
        cell.accessoryType = arrayOfTheList[indexPath.row].done ? .checkmark : .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTheList.count
    }
    
    //TODO: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arrayOfTheList[indexPath.row])
        
        arrayOfTheList[indexPath.row].done = !arrayOfTheList[indexPath.row].done
        
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        saveDataAndUpdate()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: New section add / Bar button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            // What will happen when the user click alert button
            
            
            let textFieldItemTitle = Item()
            textFieldItemTitle.title = textField.text!
            self.arrayOfTheList.append(textFieldItemTitle)
            self.saveDataAndUpdate()
            
            
            
            //self.defaults.set(self.arrayOfTheList, forKey: "toDoListDefaults")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated : true , completion : nil)
    }
    
    func saveDataAndUpdate(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(arrayOfTheList)
            try data.write(to: directoryEncoder! )
            
        }catch{
            print("Encoding problem : \(error)")
            
        }
        tableView.reloadData()
    }
    func loadData(){
        
        if let data = try? Data(contentsOf: directoryEncoder!) {
            let decoder = PropertyListDecoder()
            
            do{
                arrayOfTheList = try decoder.decode([Item].self, from: data)
            }catch{
                print("\(error)")
            }
        
        }
    }

}

