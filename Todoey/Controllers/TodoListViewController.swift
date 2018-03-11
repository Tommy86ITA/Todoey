//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 09/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    //MARK: - dichiarazione variabili di istanza:
    
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    
    // MARK: - viewDidLoad Function:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destory demogorgon"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - metodi di tableView Datasource:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - metodi delegati di tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuova voce a Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi voce", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi voce" nella UIAlert
            
            let itemToAdd = Item()
            itemToAdd.title = textField.text!
            
            self.itemArray.append(itemToAdd)                                //aggiungo il nuovo oggetto all'array
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()                                     //ricarico i dati nella tableView
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crea una nuova voce"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
}

