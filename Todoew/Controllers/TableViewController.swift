//
//  TableViewController.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/9/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var toDoItem : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
     if   let item  =  toDoItem?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            // ternary Operator ==>
            // Value = condition ? ValueIfTrue : ValueIfFalse
            //        if item.done == true{
            //            cell.accessoryType = .checkmark
            //        }else{
            //            cell.accessoryType = .none
            //        }
            cell.accessoryType = item.done ? .checkmark : .none
     }else{
        cell.textLabel?.text = "No Item Added"
        }
        return cell
        
    }
 
    // MARK: - Table view deleget Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error while updating \(error)")
        
            }
        }
        
          tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()

//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        toDoItem[indexPath.row].done = !toDoItem[indexPath.row].done


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
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textFiled.text!
                        newItem.dateCreated = Data()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error while saving \(error)")
                }
            }
            self.tableView.reloadData()
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
    


    func loadItems()  {
        
        toDoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

extension TableViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItem = toDoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

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

