//
//  RecipeServie.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 08/12/2022.
//

import Foundation
import Alamofire

// This class provides a service for retrieving recipes from an API
class RecipeService {
    
    var service = Service(networkRequest: AlamofireNetworkRequest())
    // The initializer for the RecipeService class
    init(service: Service) {
        self.service = service
    }
    // An error type specific to the RecipeService class
    class RecipeError: Error {
    }
    
    // An instance of the RecipeError class that will be used to represent errors
    let recipeError = RecipeError()
    
    
    
    // Cette fonction prend en paramètre une liste d'ingrédients disponibles (optionnelle), un lien vers une recette (optionnel) et une closure qui sera appelée lorsque la réponse de l'API sera reçue
    func getRecipes(availableIngredients: [String]?, link: String?, then closure: @escaping (Recipes?, Error?) -> Void) {
            
        // Créer l'URL de l'API endpoint
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        
        // Créer une requête URL à partir de l'URL
        var urlRequest = URLRequest(url: url!)
        
        if let ingredients = availableIngredients {
            // Si des ingrédients sont fournis, les ajouter à la requête sous forme de chaîne séparée par des virgules
            let ingredientString = ingredients.joined(separator: ", ")
            // Créer un dictionnaire de paramètres à envoyer avec la requête
            let parameters: [String: Any] = [
                "app_id": "f9e36a00",
                "app_key": "9b714c18b1141015cb3299c458486542",
                "q": ingredientString,
                "type": "public"
            ]
            // Encoder les paramètres sous forme de chaîne de requête et les ajouter à la requête URL
            urlRequest = try! URLEncoding.queryString.encode(urlRequest, with: parameters)
        } else if let link = link {
            // Si un lien de recette est fourni, utiliser ce lien comme URL de requête
            urlRequest.url = URL(string: link)
        }

        // Appeler la méthode "load" de la classe "Service" pour envoyer la requête à l'URL
        service.load(url: urlRequest.url!) { (data, response, error) in
            guard response!.statusCode == 200 else {
                closure(nil, self.recipeError)
                return
            }
            if let error = error {
                print(error)
                closure(nil, error)
            } else if let data = data {
                do {
                    // Tenter de décoder les données de réponse en un objet Recipes en utilisant JSONDecoder
                    let recipeResult: Recipes = try JSONDecoder().decode(Recipes.self, from: data)
                    // Si la décoderie est réussie, retourner l'objet Recipes à la closure
                    closure(recipeResult, nil)
                } catch {
                    // Si une erreur se produit pendant le décodage, retourner l'erreur à la closure
                    closure(nil, self.recipeError)
                }
                
            } else {
                closure(nil, self.recipeError)
            }
        }
        
        
    }
    
    
    // Cette fonction prend en paramètre une chaîne de caractères représentant l'URL de l'image à récupérer, ainsi qu'une closure qui sera appelée lorsque la réponse de la requête sera reçue
    func getImage(urlString: String, then closure: @escaping (Data?, Error?) -> Void) {
        // Vérifier que l'URL fournie est valide
        guard let url = URL(string: urlString) else {
            // Si l'URL est invalide, retourner une erreur prédéfinie (self.recipeError) à la closure et quitter la fonction
            closure(nil, self.recipeError)
            return
        }


        // Appeler la méthode "load" de la classe "Service" pour envoyer la requête à l'URL
        service.load(url: url) { (data, response, error) in
            guard response!.statusCode == 200 else {
                closure(nil,  self.recipeError)
                return
            }
            if let error = error {
                closure(nil, error)
            } else if let data = data {
                closure(data, nil)
            } else {
                closure(nil, self.recipeError)
            }
        }
    }
}



