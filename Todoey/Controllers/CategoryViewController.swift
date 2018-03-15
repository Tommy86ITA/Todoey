//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 12/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //MARK: - dichiarazione variabili di istanza:
    
    let realm = try! Realm()                // inizializzo il punto di accesso al realm
    
    var categories : Results<Category>?     // inizializzo il contenitore per l'elenco delle categorie
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()                    // carico dal realm l'elenco delle categorie
        
        
    }
    
    
    //MARK: - metodi Datasource di tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1   //se categories.count è nil, allora ritorna 1 (Nil Coalescing Operator)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.cellColor) else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        return cell
    }
    
    
    //MARK: - metodi delegati di tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi Categoria", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi categoria" nella UIAlert
            
            let categoryToAdd = Category()
            
            if textField.text != "" {
                categoryToAdd.name = textField.text!
            }
            else {
                categoryToAdd.name = "Nuova categoria"
            }
            
            categoryToAdd.cellColor = UIColor.randomFlat.hexValue()
            self.save(category: categoryToAdd)
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Crea una nuova categoria"
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - metodi di manipolazione dati
    
    // Metodo di salvataggio delle categorie
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving to realm \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // Metodo di caricamento delle categorie
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()                                              //ricarico i dati nella tableView
        
    }
    
    // Metodo di eliminazione delle categorie (tramite Swipe)
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting object in realm, \(error)")
            }
        }
    }
    
    
}





