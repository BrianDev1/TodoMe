//
//  ViewController.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/17.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoData]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   // let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
       // print(dataFilePath)
        
        loadItems()
        
//        let newItem = TodoData()
//        newItem.title = "Find Mike"             //Initial Items
//        itemArray.append(newItem)
//
//        let newItem2 = TodoData()
//        newItem2.title = "Buy Eggos"             //Initial Items
//        itemArray.append(newItem2)
//
//        let newItem3 = TodoData()
//        newItem3.title = "Destroy Demogorgon"             //Initial Items
//        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListItemsArray") as? [TodoData] {
//                        itemArray = items;
//            }
        
        tableView.separatorStyle = .singleLine;
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title;  //Label in every cell
        
        //Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.checked ? .checkmark : .none
        
//        if (item.checked == true) {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none        // Remove CheckMark
//            itemArray[indexPath.row].checked = false;
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;   //Adding an accessory to each cell that was selected
//            itemArray[indexPath.row].checked = true;
//        }
//        if itemArray[indexPath.row].checked == false {
//            itemArray[indexPath.row].checked = true;
//        } else {
//            itemArray[indexPath.row].checked = false;
//        }
        
        //simplified
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked // If it was checked then set oposite and vice versa
        
        saveData() //Calling savedata method
        
        //tableView.reloadData()  // Reload data to get new data set above from the objects
        
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
                
            let newItem = TodoData()
            
                newItem.title = textField.text!;
                self.itemArray.append(newItem);
            //self.itemArray.append(textField.text!) // in a closure
                
                self.saveData()
                
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
    
    func saveData() {
        
        let encoder = PropertyListEncoder() //Creating an encoder to encode our data
        
        do{
            let data = try encoder.encode(itemArray)    // Encoding our data
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
       
        tableView.reloadData()
        
    }
    
    func loadItems() {
        if let data = try? Data (contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()                         // Decoding our data
            do{
               itemArray = try decoder.decode([TodoData].self, from: data)
            } catch {
                print("Error decoding items, \(error)")
            }
        }
    }
    


}

