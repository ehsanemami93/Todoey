//
//  CategoryViewController.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/17/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

    }
    
    
   // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryList", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
        
    }
    
    // MARK: - Tableview Deleget Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinstionVC = segue.destination as? TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinstionVC?.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manupulation Methods
    
    func saveData (){
        do{
        try contex.save()
        }catch{
            print("Error in saveing \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try categories = contex.fetch(request)
        }catch{
            print("Error Fetching \(error) ")
        }
    }
   
    
    
    
    
    // MARK: - Add New Categories
    
    

    @IBAction func addButtomPress(_ sender: UIBarButtonItem) {
        
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            let newItem = Category(context: self.contex)
            newItem.name = texField.text!
            self.categories.append(newItem)
            self.saveData()
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
