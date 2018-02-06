//
//  ToDoListViewController.swift
//  ToDoIt
//
//  Created by Brian Wilson on 1/26/18.
//  Copyright © 2018 Brian Wilson. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var dateCreated = Date()
    
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
           loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCategory!.name + " Items"
        
        
    }
    
    //MARK: - TableView Datasoure Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoItems?.count == nil || todoItems?.count == 0 {
            print("returning 1")
            return 1
        } else {
            print("returning count", todoItems?.count as Any)
            return todoItems!.count
        }
        
        //return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
        //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        todoItems[indexPath.row].done = false
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - Model Manipulation Methods
    
    func saveItems(items: Item) {
        
        do {
            try realm.write {
                realm.add(items)
            }
        } catch {
            print("error saving context", error)
        }
    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    
}

//MARK: - SearchBar Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "date created", ascending: true)
            tableView.reloadData()
        }
    }
}


