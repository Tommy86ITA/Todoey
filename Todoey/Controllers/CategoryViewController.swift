//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 12/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //MARK: - dichiarazione variabili di istanza:
    
    let realm = try! Realm()                // inizializzo il punto di accesso al realm
    
    var categories : Results<Category>?     // inizializzo il contenitore per l'elenco delle categorie
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()                    // carico dal realm l'elenco delle categorie
        
        
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuova Categoria", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi categoria" nella UIAlert
            
            let categoryToAdd = Category()
            
            if textField.text != "" {
                categoryToAdd.name = textField.text!
            }
            else {
                categoryToAdd.name = "Nuova categoria"
            }
    
            self.save(category: categoryToAdd)
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
        
        return categories?.count ?? 1   //se categories.count è nil, allora ritorna 1 (Nil Coalescing Operator)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Non hai ancora aggiunto una categoria"
        
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
    
    
}
