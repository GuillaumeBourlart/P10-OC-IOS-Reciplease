//
//  FavoriteRecipeTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Bourlart on 15/01/2023.
//

@testable import Reciplease
import XCTest
import Foundation
import CoreData
import UIKit
import OHHTTPStubs

final class FavoriteRecipeTests: XCTestCase {
    
    override  func setUp() {
        FavoriteRecipe.reset { success in
            print("reset")
        }
    }

    func testThereIsOnlyONeFavoriteRecipe_WhenWeTryToGEtNUmbersOfRecipes_ThenWeGot1() {
        // Arrange
           let mockRecipe = FavoriteRecipe(context: CoreDataStack.sharedInstance.viewContext)
           mockRecipe.label = "Mock recipe"
           mockRecipe.ingredientsLine = ["ingredient 1", "ingredient 2"] as NSObject
        let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageData = image!.pngData()
        let data = imageData
           mockRecipe.image = data
           mockRecipe.link = "www.mockrecipe.com"
        try? CoreDataStack.sharedInstance.viewContext.save()
           
        // Act
        let allRecipes = FavoriteRecipe.all
           
        // Assert
        XCTAssertEqual(allRecipes.count, 1) // make sure there is only one recipe in the store
        XCTAssertEqual(allRecipes[0].label, "Mock recipe")
        XCTAssertEqual(allRecipes[0].ingredientsLine as? [String], ["ingredient 1", "ingredient 2"])
        XCTAssertNotNil(allRecipes[0].image)
        XCTAssertEqual(allRecipes[0].link, "www.mockrecipe.com")
    }
    
    func testThereIsONeFavoriteRecipe_WhenWeTryToResetFavoriteRecipes_ThenThereIsNoFavortieRecipeAnymore() {
        // Arrange
        let mockRecipe = FavoriteRecipe(context: CoreDataStack.sharedInstance.viewContext)
        mockRecipe.label = "Mock recipe"
        try! CoreDataStack.sharedInstance.viewContext.save()
        
        // Act
        FavoriteRecipe.reset { (success) in
            // Assert
            XCTAssertTrue(success)
            XCTAssertEqual(0, FavoriteRecipe.all.count)
        }
    }
    
    func testThereIsNoFavoriteRecipe_WhenWeTryToAddOne_ThenWeHaveOneFavoriteRecipe() {
        let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)?.pngData()
        
        // Act
        FavoriteRecipe.addNewFavoriteRecipe(label: "Mock recipe", ingredientsLine: ["", "", ""], ingredients: ["ingredient 1", "ingredient 2"], image: image!, link: "www.mockrecipe.com") { (success) in
            // Assert
            XCTAssertTrue(success)
            XCTAssertEqual(1, FavoriteRecipe.all.count)
            XCTAssertEqual(FavoriteRecipe.all[0].label, "Mock recipe")
        }
    }
    
    func testThereIsOneFavoriteRecipe_WhenWeTryToDeleteIt_ThenWeHaveNoFavoriteRecipeAnymore() {
        FavoriteRecipe.reset { success in
        }
        // Arrange
        let mockRecipe = FavoriteRecipe(context: CoreDataStack.sharedInstance.viewContext)
        mockRecipe.link = "link of recipe"
        try! CoreDataStack.sharedInstance.viewContext.save()
        
        // Act
        FavoriteRecipe.deleteFavoriteRecipe(recipeLink: "link of recipe") { (success) in
            // Assert
            XCTAssertTrue(success)
            XCTAssertEqual(0, FavoriteRecipe.all.count)
        }
    }
    
    func testThereIsOneFavoriteRecipe_WhenWeAskIfRecipeIsAlreadyInFavorite_ThenResultIsTrue() {
        // Arrange
        
        let mockRecipe = FavoriteRecipe(context: CoreDataStack.sharedInstance.viewContext)
        mockRecipe.link = "link of recipe"
        try! CoreDataStack.sharedInstance.viewContext.save()
        
        // Act
        let result = FavoriteRecipe.recipeIsAlreadyInFavorites(recipeLink: "link of recipe")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    
        

}
