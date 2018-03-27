//
//  SwipeTableViewController.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/27.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    }
    
    //MARK - tableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }

//MARK - Swipe cell delegate methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print(String(indexPath.row) + " Item has been deleted")
            
            self.updateModel(at: indexPath)
            
        }
        
        deleteAction.image = UIImage(named: "delete-Icon")  //Name of the Image in my assets
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive // Check pod documents to see different styles
        
        options.transitionStyle = .border
        
        return options
        
    }
    
    
    func updateModel(at indexPath: IndexPath) {
        //update dataModel
        
    }
    
    
}

