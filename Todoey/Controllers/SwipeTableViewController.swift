//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 14/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    // Metodi Datasource di TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    // Metodo gestione Swipe
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Elimina") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: "Modifica") { (action, indexPath) in
            self.editModel(at: indexPath)
            print("Editing mode")
            
        }
        
        // customize the action appearance
        editAction.image = UIImage(named: "edit-icon")
        editAction.backgroundColor = UIColor.flatSkyBlue
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction, editAction]
    }
    
    
    
    // Personalizzazione delle carattistiche dello Swipe
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
    // Metodo di aggiornamento del modello dati
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
    // Metodo di modifica del dato
    
    func editModel(at indexPath: IndexPath) {
        
        
    }
    

}
