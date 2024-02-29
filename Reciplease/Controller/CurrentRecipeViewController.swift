//
//  RecipeIngredientListViewController.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 09/12/2022.
//

import Foundation
import UIKit
import SafariServices

class CurrentRecipeViewController: UIViewController{
    // Create instance of RecipeService for API calls
    let recipeService = RecipeService(service: Service(networkRequest: AlamofireNetworkRequest()))
    // ID of the Reusable Cell
    static var cellIdentifier = "RecipeIngredientCell"
    
    
    var label : String?
    var image: Data?
    // List linked to UITableView
    var ingredientsLine = [String]()
    var ingredients = [String]()
    var link : String?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recipeIngredientsList: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func viewDidLoad() {
            // Call displayInformations function to display recipe details
        displayInformations()
        
        recipeLabel.accessibilityLabel = label
        imageView.accessibilityLabel = "image for" + label!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if the current recipe is already a favorite and set the favoriteButton image accordingly
        if FavoriteRecipe.recipeIsAlreadyInFavorites(recipeLink: link!) {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favoriteButton.tintColor = UIColor(named: "customGreen")
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favoriteButton.tintColor = UIColor.white
        }
    }
    
    func displayInformations(){
        // Display the recipe label
        recipeLabel.text = self.label
        
        // Display the recipe image
        DispatchQueue.main.async {
            self.imageView.image =  UIImage(data: self.image!)
        }
        
        
    }
    
    
    
    @IBAction func instructionsButtonWasPressed(_ sender: Any) {
        // Open the recipe instructions in a SafariViewController when the instructionsButton is pressed
        if let link = link {
            if let url = URL(string: link) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func favoriteButtonWasPressed(sender: UIButton){
        // Add or remove the current recipe from favorites when the favoriteButton is pressed
        if let link = self.link {
            if FavoriteRecipe.recipeIsAlreadyInFavorites(recipeLink: link) {
                // If the current recipe is already a favorite, delete it from favorites
                FavoriteRecipe.deleteFavoriteRecipe(recipeLink: link) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            self.favoriteButton.tintColor = UIColor.white
                        }
                    }
                }
            } else {
                
                // If the current recipe is not already a favorite, add it to favorites
                FavoriteRecipe.addNewFavoriteRecipe(label: label!, ingredientsLine: ingredientsLine, ingredients: ingredients, image: image!, link: link) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            self.favoriteButton.tintColor = UIColor(named: "customGreen")
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInstructions", let instructions = link {
            // Send the link to the recipe instructions to the destination controller when segueing to the InstructionsVC
            let destinationVC = segue.destination as? InstructionsViewController
            destinationVC?.link = instructions
        }
    }
}


extension CurrentRecipeViewController: UITableViewDataSource {
    
    // This method creates and returns a table view cell with the correct identifier and data for the given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentRecipeViewController.cellIdentifier, for: indexPath)
        
        // Get the ingredient for the current row and set it as the text for the cell
        let ingredient = ingredientsLine[indexPath.row]
        cell.textLabel?.text = "- " + ingredient
        
        // Set the accessibility label for the cell to be the ingredient, so that it can be read by accessibility tools
        cell.textLabel?.accessibilityLabel = ingredient
        
        // Return the configured cell
        return cell
    }
    
    // This method returns the number of sections in the table view. In this case, there is only one section.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method returns the number of rows in the table view, which is the same as the number of ingredients in the ingredientsList.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsLine.count
    }
}



