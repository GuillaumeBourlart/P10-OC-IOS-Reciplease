//
//  RecipeTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Bourlart on 15/01/2023.
//

@testable import Reciplease
import XCTest
import Foundation
import CoreData
import UIKit


final class RecipeTests: XCTestCase {

    func testRecipesDecoding() throws {
        // Given
        let json = """
        {
            "from": 0,
            "to": 10,
            "_links": {
                "next": {
                    "href": "https://example.com/recipes?from=10&to=20",
                    "title": "Next page"
                }
            },
            "hits": [
                {
                    "recipe": {
                        "label": "Spaghetti Carbonara",
                        "image": "https://example.com/spaghetti-carbonara.jpg",
                        "shareAs": "https://example.com/recipes/spaghetti-carbonara",
                        "ingredientLines": ["spaghetti", "eggs", "bacon", "parmesan cheese"],
                        "ingredients": [
                            {
                                "food": "spaghetti"
                            },
                            {
                                "food": "eggs"
                            },
                            {
                                "food": "bacon"
                            },
                            {
                                "food": "parmesan cheese"
                            }
                        ]
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let recipes = try JSONDecoder().decode(Recipes.self, from: json)
        
        // Then
        XCTAssertEqual(recipes.from, 0)
        XCTAssertEqual(recipes.to, 10)
        XCTAssertEqual(recipes._links.next.href, "https://example.com/recipes?from=10&to=20")
        XCTAssertEqual(recipes._links.next.title, "Next page")
        XCTAssertEqual(recipes.hits.count, 1)
        XCTAssertEqual(recipes.hits[0].recipe.label, "Spaghetti Carbonara")
        XCTAssertEqual(recipes.hits[0].recipe.image, "https://example.com/spaghetti-carbonara.jpg")
        XCTAssertEqual(recipes.hits[0].recipe.shareAs, "https://example.com/recipes/spaghetti-carbonara")
        XCTAssertEqual(recipes.hits[0].recipe.ingredientLines, ["spaghetti", "eggs", "bacon", "parmesan cheese"])
        XCTAssertEqual(recipes.hits[0].recipe.ingredients.count, 4)
        XCTAssertEqual(recipes.hits[0].recipe.ingredients[0].food, "spaghetti")
        XCTAssertEqual(recipes.hits[0].recipe.ingredients[1].food, "eggs")
        XCTAssertEqual(recipes.hits[0].recipe.ingredients[2].food, "bacon")
        XCTAssertEqual(recipes.hits[0].recipe.ingredients[3].food, "parmesan cheese")
    }
}
