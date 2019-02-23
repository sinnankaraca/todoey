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
    
    var arrayOfCategories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromRealm()
        
    }
    
    //MARK: - TableViewNumberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If it is nil then make it 1
        return arrayOfCategories?.count ?? 1
    }
    
    //MARK: - TableViewCellForRowAtIndexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for : indexPath)
        
        cell.textLabel?.text = arrayOfCategories?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    //MARK: - AddButtonPressed - Alert Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ADD", style: .default) { (UIAlertAction) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveFromRealm(category: newCategory)
            
        }
        alert.addTextField { (AlertTextField) in
            AlertTextField.placeholder = "Add New Category"
            textField = AlertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = arrayOfCategories?[indexPath.row]
            
        }
    }
    
    //MARK: - Add context to Realm
    func saveFromRealm(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error on SaveContextCoreData \(error)")
        }
 
        tableView.reloadData()
    }
    //MARK: - Load context from Realm
    func loadFromRealm(){
        
        arrayOfCategories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
}
    
    
