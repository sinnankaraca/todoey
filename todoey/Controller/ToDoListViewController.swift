//
//  ViewController.swift
//  todoey
//
//  Created by Sinan MacBook on 11.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Where the coredata is saved.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   
    }
    
    //TODO: TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell" , for : indexPath)
        
        if let item  = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //TODO: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    // To delete the item from realm
                        //self.realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Deleting item error \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: New section add / Bar button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            // What will happen when the user click alert button
            
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }catch{
                    print("Error on SaveContextCoreData \(error)")
                }
            }
            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            print(alertTextField.text!)
        }
        alert.addAction(action)
        present(alert, animated : true , completion : nil)
    }
    
    
    func loadData(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title" , ascending: true)
        tableView.reloadData()

    }

}
// MARK - Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
}
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
              searchBar.resignFirstResponder()
            }
            
        }
    }
 
}
