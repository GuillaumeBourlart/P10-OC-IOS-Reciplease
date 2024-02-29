//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 07/12/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //List containing ingredients owned by user
    var availableIngredients: [String] = []
    //ID of the Reusable Cell
    static var cellIdentifier = "IngredientCell"
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // Reset the list of ingredients
    @IBAction func clearButtonWasPressed(_ sender: Any) {
        availableIngredients = []
        tableView.reloadData()
    }
    
    // Add an ingredient to the list of ingredients
    @IBAction func addButtonWasPressed(_ sender: Any) {
        if let input = input.text,
           input != "" {
            if availableIngredients.contains(input) == false {
                availableIngredients.append(input)
                tableView.reloadData()
            }
            else{
                print("already in list")
            }
        }
    }
    
    // Perform the segue when search button is pressed
    @IBAction func searchButtonWasPressed(_ sender: Any) {
        if availableIngredients.isEmpty == false {
            performSegue(withIdentifier: "goToRecipeList", sender: availableIngredients)
        }
    }
    
    
    // function called before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeList", let ingredients = sender as? [String] {
            // Send the list of ingredients to the destination controller
            let destinationVC = segue.destination as? RecipesListViewController
            destinationVC?.availableIngredients = ingredients
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        input.resignFirstResponder()
    }
    
    
}


// Extension for table view data source
extension SearchViewController: UITableViewDataSource {
    
    // Set up the table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.cellIdentifier, for: indexPath)
        let ingredient = availableIngredients[indexPath.row]
        cell.textLabel?.text = "- " + ingredient
        cell.textLabel?.accessibilityLabel = ingredient
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    // Set the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableIngredients.count
    }
    
    // Handle deletion of a row in the table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            availableIngredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
       }
    
}




