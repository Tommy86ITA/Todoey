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
    
   
   var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // MARK: - viewDidLoad Function:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - didReceiveMemoryWarning function
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    //MARK: - metodi di tableView Datasource:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - metodi delegati di tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print (itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuova voce a Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi voce", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi voce" nella UIAlert
            
            self.itemArray.append(textField.text ?? "Nuova voce")           //aggiungo il nuovo oggetto all'array
            
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

