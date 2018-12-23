//
//  TableViewController.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/9/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item  =  itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // ternary Operator ==>
        // Value = condition ? ValueIfTrue : ValueIfFalse
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        cell.accessoryType = item.done ? .checkmark : .none
        

        
        return cell
        
    }
 
    // MARK: - Table view deleget Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
//        if tableView.cellForRow(at:indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
//
//            tableView.cellForRow(at:indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//        }else{
//            tableView.cellForRow(at:indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//        }
    }
    
    
     // MARK: - Add New Items
    
    @IBAction func addbuttomPressed(_ sender: UIBarButtonItem) {
        
        /*
         Solution about print item in the textFiled placeholder
         1) https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
         
         2)add a local variable to access all over IBAction
         */
        
        var textFiled = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen the once user clicks the add item buttom on our uiAlert
            let newItem = Item(context: self.contex)
            newItem.title = textFiled.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            //self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { (uitextfiled) in
            uitextfiled.placeholder = "Creat New Item"
            textFiled = uitextfiled
            
        })
        
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action2)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Data Manupulation Methods
    
    func saveItems()  {
        
        do{
            try contex.save()
        }catch{
            print("saving error \(error) ")
        }
        self.tableView.reloadData()

    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {
     
      //  let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additinalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additinalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            try itemArray = contex.fetch(request)
        }catch{
            print("ErrorErrorErrorErrorErrorErrorErrorError Fetching \(error) ")
        }
        tableView.reloadData()
    }

}

extension  TableViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request , predicate: predicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}
 
