//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Sinan MacBook on 23.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayOfCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadContextFromCoreData()
        
    }
    
    //MARK: - TableViewNumberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    //MARK: - TableViewCellForRowAtIndexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for : indexPath)
        
        cell.textLabel?.text = arrayOfCategories[indexPath.row].name
        
        return cell
    }
    //MARK: - TableView Delegate Methods - Segue methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = arrayOfCategories[indexPath.row]
        }
        
    }
    
    //MARK: - AddButtonPressed - Alert Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ADD", style: .default) { (UIAlertAction) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.arrayOfCategories.append(newCategory)
            self.save(category: newCategory)
            
        }
        alert.addTextField { (AlertTextField) in
            AlertTextField.placeholder = "Add New Category"
            textField = AlertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Add context to Coredata
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error on SaveContextCoreData \(error)")
        }
 
        tableView.reloadData()
    }
    //MARK: - Load context from CoreData
//    func loadContextFromCoreData(request : NSFetchRequest<Category> = Category.fetchRequest()){
//        
//        do{
//            arrayOfCategories = try context.fetch(request)
//        }catch{
//            print("Error on loadContextFromCoreData \(error)")
//        }
//        
//    }
    
    
}
    
    
