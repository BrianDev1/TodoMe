//
//  ViewController.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/17.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<TodoData>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .singleLine;
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title;  //Label in every cell
        
        //Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.checked ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }

        
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.checked = !item.checked  //Opposite of watevr it was  UPDATE
                }
            }catch{
                  print("Error saving Checked Status, \(error)")
                }
            }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert);//Popup
        var textField = UITextField();
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add button on UI alert
            print("Add Item pressed, Success!");
            
            if(textField.text != ""){
              
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = TodoData()
                        newItem.title = textField.text!;
                        newItem.dateCreated = Date();
                        currentCategory.items.append(newItem)
                    }
                   // self.saveData(data: newItem)
                } catch {
                    print("Error Saving new items, \(error)")
                }
            }
                
            } else {
                print("Empty!")
            }
            self.tableView.reloadData();//Reload data for table view
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item..."
            
            textField = alertTextField  //Assigning the alert text field to our own
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveData(data: TodoData) {
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch  {
            print("Couldnt save item, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK - Delete Item via updateData in super class
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error Deleting item, \(error)")
            }
        }
    }
    
}


//MARK - SEARCH Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // Remove keyboard and cursor if no text
            }

        }
    }
}







