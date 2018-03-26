//
//  CategoryViewController.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/25.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }

  //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message:"", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            print("Add Category Pressed")
            
            if(textField.text != ""){
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categoryArray.append(newCategory)  //Adding the newly entered cstegory to the array
                
                self.saveData()  // Saving the current context to DB
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let categoryItem = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryItem.name
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
   
    //MARK - TableView Manipulation Methods
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error Fetching the Context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}
