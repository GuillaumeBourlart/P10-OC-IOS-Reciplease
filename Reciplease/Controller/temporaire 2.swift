//
////  RecipeIngredientListViewController.swift
////  Reciplease
////
////  Created by Guillaume Bourlart on 09/12/2022.
////
//
//import Foundation
//import UIKit
//
//class RecipeIngredientListViewController: UIViewController{
//
//    static var cellIdentifier = "RecipeIngredientCell"
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var ingredientList = [String]()
//
//    override func viewDidLoad() {
//    }
//
//}
//
//
//
//extension RecipeIngredientListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeIngredientListViewController.cellIdentifier, for: indexPath)
//        let ingredient = ingredientList[indexPath.row]
//        cell.textLabel?.text = "- " + ingredient
//        cell.textLabel?.textColor = UIColor.white
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ingredientList.count
//    }
//}
//@
