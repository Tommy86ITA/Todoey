//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 09/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //MARK: - dichiarazione variabili di istanza:
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()                    // inizializzo il punto di accesso al realm
    
    var todoItems: Results<Item>?               // inizializzo il contenitore per l'elenco degli elementi
    
    var selectedCategory : Category? {
        didSet{
            loadItems()               // carico i dati solo nel momento in cui a selectedCategory viene assegnato un valore
        }
    }
    
    
    // MARK: - viewDidLoad Function:
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.cellColor  else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    
    //MARK: - NavBar setup
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist!") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    
    //MARK: - metodi Datasource di tableView:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))      // indice corrente / indici totali
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "Non hai ancora aggiunto nessun elemento"
        }
        
        return cell
    }
    
    
    
    //MARK: - metodi delegati di tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = todoItems?[indexPath.row] else { fatalError() }
            do {
                try realm.write {
                    item.done = !item.done
                    // se volessi eseguire un'operazione di cancellazione userei realm.delete(item)
                }
            } catch {
                print("Error saving to realm, \(error)")
            }
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuovo Elemento a Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi voce" nella UIAlert
            
            guard let currentCategory = self.selectedCategory else { fatalError() }
                
                do {
                    try self.realm.write {
                        let itemToAdd = Item()
                        if textField.text != "" {
                            itemToAdd.title = textField.text!
                        }
                        else {
                            itemToAdd.title = "Nuova voce"                              //Se il campo con il nome della nuova voce è vuoto, lo imposto come "Nuova voce"
                        }
                        itemToAdd.dateCreated = Date()
                        itemToAdd.done = false
                        currentCategory.items.append(itemToAdd)
                    }
                } catch {
                    print("Error saving to realm, \(error)")
                }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crea un nuovo elemento"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Metodo di caricamento degli elementi
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    
    //MARK: - Metodo di eliminazione degli elementi tramite Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting object in realm, \(error)")
            }
        }
    }
    
}



//MARK: - metodi della Search Bar

extension TodoListViewController: UISearchBarDelegate {
    
    // Metodo di ricerca
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)   //cerca gli elementi che all'interno dell'attributo title CONTENGONO ciò che viene scritto nella searchbar (%@). [cd] indica che la ricerca non fa distinzione fra maiuscole e minuscole (non case-sensitive) e non considera i diacritici (é,è,à, ō...)
        
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)  //scelgo di ordinare i risultati disponendoli secondo il titolo in ordine alfabetico
        
        tableView.reloadData()                                             //ricarico i dati nella tableView
        
    }
    
    
    // Metodo di ritorno
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {                                 // se nella searchBar non c'è nessun carattere....
            loadItems()                                                 // ricarica i dati
            
            DispatchQueue.main.async {                                  // richiedo di utilizzare in modo asincorono il main thread tramite la dispatch queue
                searchBar.resignFirstResponder()                        // la searchBar cessa di essere il firstResponder, avvisando l'OS che può nascondere la tastiera
                
            }
        }
    }
}

