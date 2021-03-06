//
//  CategoryViewController.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/25.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()          //Creating a new realm
    
    var categoryArray: Results<Category>?  // Collection type, of results that are category objects
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
             //Setting row height

        loadData()
        
    }

  //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message:"", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            print("Add Category Pressed")
            
            if(textField.text != ""){
                let newCategory = Category()
                newCategory.name = textField.text!
                //self.categoryArray.append(newCategory)  //Adding the newly entered cstegory to the array
                
                self.saveData(category: newCategory)  // Saving the current context to DB
            } else {
                print("Empty Category")
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1   //If nil then assign 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  // overriding the super class function and setting the cell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
   
    //MARK - TableView Manipulation Methods
    
    func saveData(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        
        categoryArray = realm.objects(Category.self)  //Load all our categories
    
       tableView.reloadData()
        
    }
    
    //MARK - Delete Data From Swipe, overriding the update from superclass
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {  //Optional Binding to handle the optional
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting at the cell with, \(error)")
            }
            //tableView.reloadData()
        }
    }
}









