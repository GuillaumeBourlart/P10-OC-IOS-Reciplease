////
////  File.swift
////  Reciplease
////
////  Created by Guillaume Bourlart on 08/12/2022.
////
//
//import Foundation
//import UIKit
//
//class RecipeListViewController: UIViewController{
//    
//    let recipeService = RecipeService(session: URLSession.shared)
//    
//    @IBOutlet weak var tableVieaw: UITableView!
//    var ingredientsList = [String]()
//    var recipeList = [String]()
//    var ingredientLines = [[String]]()
//    var selectedCell: Int?
//    static var cellIdentifier = "RecipeCell"
//    
//    override func viewDidLoad() {
//        if ingredientsList.isEmpty == false {
//            displayRecipes(list: ingredientsList)
//        }else if let recipes = UserDefaults.standard.value(forKey: "recipesName"){
//            recipeList = recipes as! [String]
//            self.tableVieaw.reloadData()
//        }
//    }
//    
//    func displayRecipes(list: [String]){
//        
//        recipeService.getRecipes(list: list) { recipes, error in
//            if error != nil {
//                print(error.debugDescription)
//            }else if let recipes = recipes {
//                for i in 0..<recipes.hits.count{
//                    self.recipeList.append(recipes.hits[i].recipe.label)
//                    for j in 0..<recipes.hits[i].recipe.ingredientLines.count {
//                        self.ingredientLines.append(recipes.hits[i].recipe.ingredientLines)
//                    }
//                }
//                UserDefaults.standard.removeObject(forKey: "recipesName")
//                UserDefaults.standard.set(self.recipeList, forKey: "recipesName")
//                print(UserDefaults.standard.value(forKey: "recipesName"))
//                UserDefaults.standard.removeObject(forKey: "recipesIngredients")
//                UserDefaults.standard.set(self.ingredientLines, forKey: "recipesIngredients")
//                print(UserDefaults.standard.value(forKey: "recipesIngredients"))
//                DispatchQueue.main.async {
//                    self.tableVieaw.reloadData()
//                }
//                
//            }
//
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToIngredientsList"{
//            let destinationVC = segue.destination as? RecipeIngredientListViewController
//            destinationVC?.ingredientList = ingredientLines[selectedCell!]
//        }
//    }
//    
//    
//    
//}
//
//
//extension RecipeListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListViewController.cellIdentifier, for: indexPath)
//        let recipeName = recipeList[indexPath.row]
//        cell.textLabel?.text = recipeName
//        cell.textLabel?.textColor = UIColor.white
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return recipeList.count
//    }
//    
//    
//
//}
//
//extension RecipeListViewController: UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        print(indexPath)
//        selectedCell = indexPath.row
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        performSegue(withIdentifier: "goToIngredientsList", sender: cell)
//    }
//}
//
