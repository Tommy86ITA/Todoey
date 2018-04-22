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
    
    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    
    let realm = try! Realm()                // inizializzo il punto di accesso al realm
    
    var categories : Results<Category>?     // inizializzo il contenitore per l'elenco delle categorie
    
   
    //MARK: - app lifecycle:
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadCategories()                    // carico dal realm l'elenco delle categorie

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist!") }
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.flatWhite]
        
        categorySearchBar.delegate = self
        categorySearchBar.placeholder = "Cerca fra le categorie"
    }
    

    //MARK: - metodi Datasource di tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1   //se categories.count == nil, allora ritorna 1 (Nil Coalescing Operator)
    }

   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let longPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_ :)))
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.detailTextLabel?.text = ("\(category.numberOfItems)")
            guard let categoryColor = UIColor(hexString: category.cellColor) else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.detailTextLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.addGestureRecognizer(longPressedRecognizer)
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
            categoryToAdd.dateCreated = Date()
            categoryToAdd.numberOfItems = 0
            self.save(category: categoryToAdd)
        }
        let cancelAction = UIAlertAction(title: "Annulla", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Crea una nuova categoria"
            textField.autocorrectionType = .yes
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - metodo di gestione UIGestureRecognizer (longPressed)
    
    @objc func longPressed(_ recognizer: UIGestureRecognizer) {
        

        if recognizer.state == UIGestureRecognizerState.ended {
            let longPressedLocation = recognizer.location(in: self.tableView)
            if let pressedIndexPath = self.tableView.indexPathForRow(at: longPressedLocation) {
                editModel(at: pressedIndexPath)
            }
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
    
    
    // Metodo di salvataggio alle modifica attributi della categoria
    
    func saveChanges(category: Category , newName: String) {
        do {
            try realm.write {
                category.name = newName
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
    
    
    // Metodo di modifica (rinominazione) delle categorie (tramite Swipe)
    
    override func editModel(at indexPath: IndexPath) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Rinomina Categoria", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Rinomina", style: .default, handler: { (action) -> Void in
            // cosa avviene quando l'utente clicca sul bottone "Rinomina" nella UIAlert
            
            let categoryToEdit = self.categories?[indexPath.row]
            self.saveChanges(category: categoryToEdit!, newName: textField.text!)
            
        })
        
        let cancelAction = UIAlertAction(title: "Annulla", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.text = self.categories?[indexPath.row].name
            textField.autocorrectionType = .yes
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
}



extension CategoryViewController: UISearchBarDelegate {
    
    // Metodo di ricerca
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("name CONTAINS[cd] %@", categorySearchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {                                 // se nella searchBar non c'è nessun carattere....
            loadCategories()                                            // ricarica i dati
            DispatchQueue.main.async {                                  // richiedo di utilizzare in modo asincorono il main thread tramite la dispatch queue
                searchBar.resignFirstResponder()                        // la searchBar cessa di essere il firstResponder, avvisando l'OS che può nascondere la tastiera
                
            }
        }
    }
}
