//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Fahmi Sulaiman on 21.01.18.
//  Copyright © 2018 Fahmi Sulaiman. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 80.0
    }
    
    // MARK:- TableView Datasource Methods
    // Methods which deals with how the TableView should appear (how many rows, what should it show, etc.)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // Nil coalesing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet"
        
        return cell
    }
    
    // MARK:- TableView Delegate Methods
    // Methods on how to deal with certain actions done to the TableView (cell selected, cell swiped, etc.)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] // Why don't we use "??" here? Because in TodoListVC, the selectedCategory is defined as an Optional so we should also be safe there
        }
    }
    
    // MARK:- Data Manipulation Methods
    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Saving new category failed!: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deletedCategory = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deletedCategory)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    // MARK:- Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
