//
//  ViewController.swift
//  Todoey
//
//  Created by Шапагат on 2/9/20.
//  Copyright © 2020 Shapagat Bolat. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    var defaults = UserDefaults.standard
    var itemArray:[Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
      
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        updatePlist()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK:-Add New Items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField?.text{
                if !text.isEmpty{
                    let newItem = Item(title: text, isDone: false)
                    self.itemArray.append(newItem)
                    self.updatePlist()
                    
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
    
    func updatePlist(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("Got some errors: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Got some errors: \(error)")
            }
        }
    }
}

