//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by Шапагат on 2/10/20.
//  Copyright © 2020 Shapagat Bolat. All rights reserved.
//

import UIKit
import CoreData
class CategoriesViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK:-TableView DataSource Methods
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell =  tableView.dequeueReusableCell(withIdentifier:"categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
         cell.textLabel?.text = category.name
        //cell.accessoryType = category.isDone ? .checkmark : .none
        return cell
        
    }
    
    
    //MARK:-Add New Items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField?.text{
                if !text.isEmpty{
                    let newCategory = Category(context:self.context)
                    newCategory.name = text
                    self.categoryArray.append(newCategory)
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
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            self.categoryArray = try context.fetch(request)
        }catch{
            print("Got some errors: \(error)")
        }
        self.tableView.reloadData()
        
        
        
       
    }
    //MARK:-Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToItems"{
            let destination = segue.destination as! TodoListViewController
           
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.selectedCategory =  categoryArray[indexPath.row]
            }
            
        }
    }
}






