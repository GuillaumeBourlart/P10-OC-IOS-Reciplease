
//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 13/12/2022.
//

import Foundation

struct Recipes: Decodable, Encodable, Equatable {
    
    struct Ingredient: Decodable, Encodable, Equatable{
//        var text: String
//        var quantity: Int
//        var measure: String
        var food: String
//        var weight: Int
//        var foodId: String
    }
    
    struct Links: Decodable, Encodable, Equatable {
//        let `self`: Link
        let next: Link
    }
    struct Hit: Decodable, Encodable, Equatable {
        let recipe: Recipe
    }
    struct Link: Decodable , Encodable, Equatable{
        var href: String
        var title: String
    }
    struct Recipe: Decodable, Encodable, Equatable{
//        let uri: String
        var label: String
        var image: String
//        let source: String
//        let url: String
        var shareAs: String
//        let yield: Int
//        let dietLabels: [String]
//        let healthLabels: [String]
//        let cautions: [String]
        var ingredientLines: [String]
        let ingredients: [Ingredient]
//        let calories: Int
//        let glycemicIndex: Int
//        let totalCO2Emissions: Int
//        let totalWeight: Int
//        let cuisineType: [String]
//        let mealType: [String]
//        let dishType: [String]
//        let instructions: [String]
//        let tags: [String]
//        let externalId: String
    }
    
//    let response: Response
//    let links: Links
//    let hit: Hit
//    let link: Link
    
    let from: Int
    let to: Int
    let _links: Links
    let hits: [Hit]
}



