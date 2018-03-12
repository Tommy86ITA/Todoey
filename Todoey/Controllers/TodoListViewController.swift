//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Amaranto on 09/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    //MARK: - dichiarazione variabili di istanza:
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    // MARK: - viewDidLoad Function:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        
        
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
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - azione aggiunta nuovo oggetto
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi nuova voce a Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aggiungi voce", style: .default) { (action) in
            // cosa avviene quando l'utente clicca sul bottone "Aggiungi voce" nella UIAlert
            
            let itemToAdd = Item(context: self.context)
            
            if textField.text != "" {
                itemToAdd.title = textField.text!
            }
            else {
                itemToAdd.title = "Nuova voce"                              //Se il campo con il nome della nuova voce è vuoto, lo imposto come "Nuova voce"
            }
            
            itemToAdd.done = false
            self.itemArray.append(itemToAdd)                                //aggiungo il nuovo oggetto all'array
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crea una nuova voce"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - metodi manipolazione del modello
    
    // Funzione di salvataggio degli oggetti
    
    func saveItems() {
        do {
            try context.save()                                              //salvo nel DB i dati contenuti nel context
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()                                              //ricarico i dati nella tableView
    }
    
    // Funzione per il caricamento dei dati
    // Richiede in ingresso un parametro request di tipo NSFetchRequest.
    // Se non viene specificato, il parametro di default è Item.fetchRequest
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
       
        do {
            itemArray = try context.fetch(request)                          //Carico i dati che ho ottenuto nella itemArray
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()                                              //ricarico i dati nella tableView
        
    }

    
    // Funzione di cancellazione dei dati
    //
    //    func deleteItem() {
    //        context.delete(itemArray[indexPath.row])
    //        itemArray.remove(at: indexPath.row)
    //    }
    
    
}

    //MARK: - metodi della Search Bar

extension TodoListViewController: UISearchBarDelegate {
    
    // Metodo di ricerca
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)   //cerca gli elementi che all'interno dell'attributo title CONTENGONO ciò che viene scritto nella searchbar (%@). [cd] indica che la ricerca non fa distinzione fra maiuscole e minuscole (non case-sensitive) e non considera i diacritici (é,è,à, ō...)
        
        
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)                              //scelgo di ordinare i risultati disponendoli secondo il titolo in ordine alfabetico
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)                   //imposto la query...
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]                         //...e la regola di ordinamento dei risultati
        
        loadItems(with: request)                                                                            //Carico i dati che corrispondono alla mia request
        
        tableView.reloadData()                                                                              //ricarico i dati nella tableView
        
    }
    
    
    // Metodo di ritorno
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {                                 // se nella searchBar non c'è nessun carattere....
            loadItems()                                                 // ricarica i dati
            
            //DispatchQueue
            searchBar.resignFirstResponder()                            // la searchBar cessa di essere il firstResponder, avvisando l'OS che può nascondere la tastiera
        }
    }
}
