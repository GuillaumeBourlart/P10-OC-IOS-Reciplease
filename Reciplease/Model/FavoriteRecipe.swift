//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 10/12/2022.
//

import Foundation
import CoreData

// This protocol defines a single method that can be used to notify a delegate when a list changes
protocol FavoriteRecipeDelegate: AnyObject {
    func listDidChange()
}

// This is a Core Data managed object class for the FavoriteRecipe entity
class FavoriteRecipe: NSManagedObject {
    
    // This static weak property is used to store a reference to a FavoriteRecipeDelegate
    static weak var delegate: FavoriteRecipeDelegate?
    
    // This static private property is used to define the fetch request for all FavoriteRecipe objects
    static private let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
    
    // This static computed property returns an array of all FavoriteRecipe objects in Core Data
    static var all: [FavoriteRecipe] {
        // Load DATA in array linked to UITableView
        guard let recipesList = try? CoreDataStack.sharedInstance.viewContext.fetch(request) else { return [] }
        return recipesList
    }
    
    // This static function resets all FavoriteRecipe objects in Core Data
    static func reset(then closure: @escaping (Bool) -> Void){
        //Reset coredata entities
        guard let recipesList = try? CoreDataStack.sharedInstance.viewContext.fetch(request) else { closure(false);  return }
        for recipe in recipesList {
            CoreDataStack.sharedInstance.viewContext.delete(recipe)
        }
        closure(true)
    }
    
    // This static function adds a new FavoriteRecipe object to Core Data
    static func addNewFavoriteRecipe(label: String, ingredientsLine: [String], ingredients: [String], image: Data, link: String, then closure: @escaping (Bool) -> Void) {
        
        // Store the input values in local variables
        let recipeLabel = label
        let recipeIngredients = ingredientsLine
        let recipeImage = image
        let recipeLink = link
        let ingredients = ingredients.joined(separator: ", ")
        
        // Check if the recipe is already in favorites
        if recipeIsAlreadyInFavorites(recipeLink: recipeLink) == false {
            // create entity instance with context
            let recipe = FavoriteRecipe(context: CoreDataStack.sharedInstance.viewContext)
            // use
            recipe.ingredientsLine = recipeIngredients as NSObject
            recipe.label = recipeLabel
            recipe.image = recipeImage
            recipe.link = recipeLink
            recipe.ingredientsForDescription = ingredients
            
            // Save the new FavoriteRecipe object to Core Data and call the closure with a success/failure flag
            do {
                try CoreDataStack.sharedInstance.viewContext.save()
                closure(true)
            } catch {
                print(error.localizedDescription.debugDescription)
                closure(false)
            }
        }
        
        // Notify the delegate that the list of FavoriteRecipe objects has changed
        delegate?.listDidChange()
    }
    
    // This static function deletes a FavoriteRecipe object from Core Data
    static func deleteFavoriteRecipe(recipeLink: String, then closure: @escaping (Bool) -> Void) {
        
        // Store the input value in a local variable
        let link = recipeLink
        
        // Get all FavoriteRecipe objects in Core Data
        guard let recipesList = try? CoreDataStack.sharedInstance.viewContext.fetch(request) else { return }
        
        // Loop through all FavoriteRecipe objects and delete the one with the matching label
        for recipe in recipesList {
            if recipe.link == link {
                CoreDataStack.sharedInstance.viewContext.delete(recipe)
            }
        }
        
        // Save the changes to Core Data and call the closure with a success/failure flag
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
            closure(true)
        } catch {
            print(error.localizedDescription.debugDescription)
            closure(false)
        }
        
        // Notify the delegate that the list of FavoriteRecipe objects has changed
        delegate?.listDidChange()
    }
    
    static func recipeIsAlreadyInFavorites(recipeLink: String) -> Bool{
        var bool = false
        // We check that the recipe isn't already in favorites
        for i in 0..<all.count{
            if all[i].link == recipeLink {
                bool = true
            }
        }
        return bool
    }
    
    
}
