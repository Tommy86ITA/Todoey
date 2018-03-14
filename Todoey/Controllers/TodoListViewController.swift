//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 09/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    //MARK: - dichiarazione variabili di istanza:
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            
            loadItems()                                 // carico i dati solo nel momento in cui a selectedCategory viene assegnato un valore
        }
    }
    
    
    
    
    // MARK: - viewDidLoad Function:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: - metodi Datasource di tableView:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
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
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // se volessi eseguire un'operazione di cancellazione userei realm.delete(item)
                }
            } catch {
                print("Error saving to realm, \(error)")
            }
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
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let itemToAdd = Item()
                        if textField.text != "" {
                            itemToAdd.title = textField.text!
                        }
                        else {
                            itemToAdd.title = "Nuova voce"                              //Se il campo con il nome della nuova voce è vuoto, lo imposto come "Nuova voce"
                        }
                        
                        itemToAdd.done = false
                        //itemToAdd.dateCreated = Date()
                        currentCategory.items.append(itemToAdd)
                    }
                } catch {
                    print("Error saving to realm, \(error)")
                }
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


//MARK: - metodi manipolazione del modello

// Metodo di salvataggio degli oggetti

//    func saveItems(item: Item) {
//        do {
//            try realm.write()   {
//                realm.add(item)
//            }                                           //salvo nel DB i dati contenuti nel context
//        } catch {
//            print("Error saving to realm: \(error)")
//        }
//
//        tableView.reloadData()                                              //ricarico i dati nella tableView
//    }

// Metodo per il caricamento dei dati
// Richiede in ingresso un parametro request di tipo NSFetchRequest.
// Se non viene specificato, il parametro di default è Item.fetchRequest

func loadItems() {
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
    
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //        if let additionalPredicate = predicate {
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    //        }
    //        else {
    //            request.predicate = categoryPredicate
    //        }
    //
    //
    //        do {
    //            todoItems = try context.fetch(request)                          //Carico i dati che ho ottenuto nella todoItems
    //        } catch {
    //            print("Error fetching data from context: \(error)")
    //        }
    
    //ricarico i dati nella tableView
    
}


// Funzione di cancellazione dei dati
//
//    func deleteItem() {
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
//    }


}

//MARK: - metodi della Search Bar

extension TodoListViewController: UISearchBarDelegate {

    // Metodo di ricerca

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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

