//
//  ViewController.swift
//  Todoey
//
//  Created by Шапагат on 2/9/20.
//  Copyright © 2020 Shapagat Bolat. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController{
    var itemArray:[Item] = []
    var selectedCategory:Category?{
        didSet{
           let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
            loadItems(predicate: predicate)
       
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:-TableView DataSource Methods
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
        
    }
    
    //MARK:-TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        updateItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK:-Add New Items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField?.text{
                if !text.isEmpty{
                    let newItem = Item(context:self.context)
                    newItem.title = text
                    newItem.isDone = false
                    newItem.parentCategory = self.selectedCategory
                    self.itemArray.append(newItem)
                    self.updateItems()
                    
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "type here..."
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK:-Model manipulation Methods
    
    func updateItems(){
        do{
            try context.save()
        }catch{
            print("Got some errors: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate){
        request.predicate = predicate

        do{
            self.itemArray = try context.fetch(request)
        }catch{
            print("Got some errors: \(error)")
        }
        self.tableView.reloadData()
    }
}

//MARK:-SearchbarDelegate Methods

extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            loadItems(predicate: predicate)
            DispatchQueue.main.async {
                searchBar.endEditing(true)
            }
            
        }
    }
}



