//
//  CategoryViewController.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/17/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

    }
    
    
   // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryList", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        return cell
        
    }
    
    // MARK: - Tableview Deleget Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinstionVC = segue.destination as? TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinstionVC?.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manupulation Methods
    
    func saveData ( category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error in saveing \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){

        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
   
    
    
    
    
    // MARK: - Add New Categories
    
    

    @IBAction func addButtomPress(_ sender: UIBarButtonItem) {
        
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            let newItem = Category()
            newItem.name = texField.text!
            self.saveData(category: newItem)
            self.tableView.reloadData()
        }
        alert.addTextField { (uiTextField) in
           uiTextField.placeholder = " Fill the Blank"
            texField = uiTextField
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(action2)
        present(alert , animated: true, completion: nil )
        
        
    }
    

}
