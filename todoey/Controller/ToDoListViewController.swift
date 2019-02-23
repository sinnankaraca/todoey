//
//  ViewController.swift
//  todoey
//
//  Created by Sinan MacBook on 11.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrayOfTheList = [Item]()
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

        
        // arrayOfTheList[indexPath.row].done = !arrayOfTheList[indexPath.row].done
        
    
//        context.delete(arrayOfTheList[indexPath.row])
//        arrayOfTheList.remove(at: indexPath.row)
        
        
        saveDataAndUpdate()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: New section add / Bar button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            // What will happen when the user click alert button
 
            
            let newItem =  Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.arrayOfTheList.append(newItem)
            self.saveDataAndUpdate()

            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            print(alertTextField.text!)
        }
        alert.addAction(action)
        present(alert, animated : true , completion : nil)
    }
    
    func saveDataAndUpdate(){
        
        //Save the data to Coredata
        
        do{
           try context.save()
            
        }catch{
           print("Error saving context \(error)")
            
        }
        tableView.reloadData()
    }
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.category MATCHES %@", selectedCategory!.category!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            arrayOfTheList = try context.fetch(request)
        } catch {
            print("Error fetch request result \(error)")
        }
        tableView.reloadData()
        
    }
    
   

}
// MARK - Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, predicate: predicate)
        
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
