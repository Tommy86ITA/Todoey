//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 09/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    // MARK: dichiarazione variabili di istanza:
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // MARK: viewDidLoad Function:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: didReceiveMemoryWarning function
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    // MARK: TableView Datasource methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    // MARK: TableView Delegate Methods
    
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
    
    
    


    

}

