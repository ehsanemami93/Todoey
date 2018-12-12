//
//  TableViewController.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/9/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var itemArray = ["milk","egg","butter"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
 
    // MARK: - Table view deleget Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at:indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            
            tableView.cellForRow(at:indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }else{
            tableView.cellForRow(at:indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
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
            self.itemArray.append(textFiled.text!)
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
    
    

}
