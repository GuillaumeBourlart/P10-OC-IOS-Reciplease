//
//  File.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 08/12/2022.
//

import Foundation
import UIKit

class RecipesListViewController: UIViewController{
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Outlet for the UITableView
    @IBOutlet weak var tableVieaw: UITableView!
    
    @IBOutlet weak var viewForActivityIndicator: UIView!
    // Create instance of RecipeService for API calls
    let recipeService = RecipeService(service: Service(networkRequest: AlamofireNetworkRequest()))
    
    // Outlet for UILabel that displays when there are no favorite recipes
    @IBOutlet weak var noFavoriteLabel: UILabel!
    
    // List of ingredients owned by user and used for API call
    var availableIngredients: [String]?
    
    // List of recipes filled after API call and linked to UITableView
    var recipes = [Any]()
    
    var nextPage : String?
    
    var isShowingFavorite = false
    // Dictionary that holds recipe images
    var recipesImages: [String: Data] = [:]
    
    // ID of the reusable cell
    static var cellIdentifier = "RecipeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForActivityIndicator.layer.cornerRadius = 10
        // Call API if list of user's ingredients is received
        if let availableIngredients = availableIngredients {
            recipes = []
            isShowingFavorite = false
            displayRecipes(availableIngredients: availableIngredients, link: nil)
        }else{
            // List of favorite recipes that will be filled after API call and linked to UITableView
            self.noFavoriteLabel.text = "No favorite recipes yet"
            recipes = []
            isShowingFavorite = true
            recipes = FavoriteRecipe.all
            // Set the delegate to the view controller itself
            FavoriteRecipe.delegate = self
        }
    }
    
    // Function called after the view controller's view appears on the screen
    override func viewDidAppear(_ animated: Bool) {
        if availableIngredients != nil {
        }else{
            // Show or hide the UILabel depending on whether there are any favorite recipes
            if recipes.isEmpty {
                tableVieaw.isHidden = true
                noFavoriteLabel.isHidden = false
            }
            else{
                tableVieaw.isHidden = false
                noFavoriteLabel.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the table view when the view appears
        tableVieaw.reloadData()
    }
    
    // Update recipes display
    func displayRecipes(availableIngredients: [String]?, link: String?) {
        activityIndicator.isHidden = false
        viewForActivityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if let availableIngredients = availableIngredients {
            // Call function that calls API
            recipeService.getRecipes(availableIngredients: availableIngredients, link: nil) { recipes, error in
                if error != nil {
                    print(error.debugDescription)
                    self.activityIndicator.isHidden = true
                    self.viewForActivityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.noFavoriteLabel.text = "No recipes found"
                    self.noFavoriteLabel.isHidden = false
                } else if let recipes = recipes {
                    // Update recipes on the main thread
                    DispatchQueue.main.async {
                        for i in 0..<recipes.hits.count {
                            self.recipes.append(recipes.hits[i].recipe)
                        }
                        self.nextPage = recipes._links.next.href
                        self.loadEveryImages()
                    }
                }
            }
        }else if let link = link {
            // Call function that calls API
            recipeService.getRecipes(availableIngredients: nil, link: link) { recipes, error in
                if error != nil {
                    print(error.debugDescription)
                } else if let recipes = recipes {
                    // Update recipes on the main thread
                    DispatchQueue.main.async {
                        for i in 0..<recipes.hits.count {
                            self.recipes.append(recipes.hits[i].recipe)
                        }
                        self.nextPage = recipes._links.next.href
                        self.loadEveryImages()
                    }
                }
            }
        }
    }
    
    // Load every recipe image
    // Load every recipe image
    func loadEveryImages() {
        var count = 0
        let total = recipes.count
        for recipe in recipes as! [Recipes.Recipe]{
            recipeService.getImage(urlString: recipe.image) { image, error in
                if let image = image {
                    // Update recipesImages dictionary on the main thread
                    DispatchQueue.main.async {
                        self.recipesImages[recipe.shareAs] = image
                        count += 1
                        if count == total {
                            // All images have been downloaded, reload table view
                            self.activityIndicator.isHidden = true
                            self.viewForActivityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.tableVieaw.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToIngredientsList", let recipe = sender! as? Recipes.Recipe? {
            // Send the list of ingredients to the destination controller
            let destinationVC = segue.destination as? CurrentRecipeViewController
            // Récupération de l'index de la cellule sélectionnée
                // Transmission de l'index à la vue de destination
                destinationVC?.label = recipe?.label
                destinationVC?.image = recipesImages[recipe!.shareAs]!
                destinationVC?.link = recipe?.shareAs
                destinationVC?.ingredientsLine = recipe!.ingredientLines
                
                var ingredients = [String]()
                for ingredient in recipe!.ingredients {
                    let ingredientLabel = ingredient.food
                    ingredients.append(ingredientLabel)
                }
                destinationVC?.ingredients = ingredients
            
            
        } else if segue.identifier == "goToIngredientsList", let recipe = sender! as? FavoriteRecipe? {
            // Send the list of ingredients to the destination controller
            let destinationVC = segue.destination as? CurrentRecipeViewController
            
                // Transmission de l'index à la vue de destination
                destinationVC?.label = recipe?.label
                destinationVC?.image = recipe?.image
                destinationVC?.link = recipe?.link
                destinationVC?.ingredientsLine = recipe!.ingredientsLine as! [String]
                
            
                destinationVC?.ingredients = (recipe?.ingredientsForDescription?.components(separatedBy: ", "))!
            
        }
        
    }
}

// Implement UITableViewDataSource protocol
extension RecipesListViewController: UITableViewDataSource {
    
    // Create and configure table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell with custom cell identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipesListViewController.cellIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        var recipeIngredients = ""
        if availableIngredients != nil {
            let recipes = recipes as! [Recipes.Recipe]
            let recipeLabel = recipes[indexPath.row].label
            
            let link = recipes[indexPath.row].shareAs
            // Set the recipe title
            cell.titleLabel?.text = recipeLabel
            cell.titleLabel.accessibilityLabel = recipeLabel
            
            // Set the recipe ingredients
            let Ingredients = recipes[indexPath.row].ingredients
            for ingredient in Ingredients {
                let ingredientLabel = ingredient.food
                cell.descriptionLabel?.text! += ingredientLabel + " ,"
                recipeIngredients += ingredientLabel + " ,"
            }
            
            if let image = recipesImages[link] {
                cell.backgroundImage.image =  UIImage(data: image)
                cell.backgroundImage.accessibilityLabel = "image for" + recipeLabel // Set accessibility label for recipe image
            }
            
            // Set the cell description label accessibility label
            cell.descriptionLabel.accessibilityLabel = cell.descriptionLabel.text
            
        }else{
            let recipes = recipes as! [FavoriteRecipe]
            let recipeLabel = recipes[indexPath.row].label
            // Set the recipe title
            cell.titleLabel?.text = recipeLabel
            cell.titleLabel.accessibilityLabel = recipeLabel
            
            // Set the recipe ingredients
            cell.descriptionLabel?.text! = recipes[indexPath.row].ingredientsForDescription!
             
            if let image = recipes[indexPath.row].image{
                DispatchQueue.main.async {
                    cell.backgroundImage.image = UIImage(data: image)
                    cell.backgroundImage.accessibilityLabel = "image for recipe " + recipeLabel!
                }
            }
            
            // Set the cell description label accessibility label
            cell.descriptionLabel.accessibilityLabel = cell.descriptionLabel.text
        }
        
        return cell // Return the configured cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // This table view only has one section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count // Return the number of recipes in the array as the number of rows in the table view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isShowingFavorite == false {
            let lastIndex = tableView.numberOfRows(inSection: 0) - 1
            if indexPath.row == lastIndex {
                // Nous sommes arrivés au dernier élément du tableau
                // Effectuez les actions appropriées, comme charger plus de données à afficher
                displayRecipes(availableIngredients: nil, link: nextPage )
            }
        }
    }
    
}

extension RecipesListViewController: UITableViewDelegate{
    // called when a cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Deselect the row after it's been clicked
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if isShowingFavorite{
            let recipe = recipes[indexPath.row] as! FavoriteRecipe// Get the recipe object for the selected row
            performSegue(withIdentifier: "goToIngredientsList", sender: recipe) // Perform segue to display the ingredients list for the selected recipe
        }else{
            let recipe = recipes[indexPath.row] as! Recipes.Recipe // Get the recipe object for the selected row
            performSegue(withIdentifier: "goToIngredientsList", sender: recipe) // Perform segue to display the ingredients list for the selected recipe
        }
       
    }
}


// This extension handles changes to the favorite recipe list
extension RecipesListViewController :FavoriteRecipeDelegate {
    // This function is called when the favorite recipe list changes
    func listDidChange() {
        DispatchQueue.main.async{
            // Reload the list of favorite recipes and the table view
            self.recipes = FavoriteRecipe.all
            self.tableVieaw.reloadData()
        }
    }
}
