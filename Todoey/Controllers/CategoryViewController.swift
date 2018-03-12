//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 12/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //MARK: - dichiarazione variabili di istanza:
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuova Categoria", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi categoria" nella UIAlert
            
            let categoryToAdd = Category(context: self.context)
            
            if textField.text != "" {
                categoryToAdd.name = textField.text!
            }
            else {
                categoryToAdd.name = "Nuova categoria"
            }
            
            self.categoryArray.append(categoryToAdd)
            
            self.saveCategories()
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Crea una nuova categoria"
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - metodi Datasource di tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - metodi delegati di tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - metodi di manipolazione dati
    
    // Metodo di salvataggio degli oggetti
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // Metodo di caricamento degli oggetti
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)                          //Carico i dati che ho ottenuto nella itemArray
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()                                              //ricarico i dati nella tableView
        
    }
    
    
}
