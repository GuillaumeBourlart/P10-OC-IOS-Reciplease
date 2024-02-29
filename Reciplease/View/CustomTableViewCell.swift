//
//  PresentTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 11/12/2022.
//

import UIKit

// This is a custom table view cell class for displaying a recipe in the recipe search results
class CustomTableViewCell: UITableViewCell {
    // The labels and images for displaying the recipe information

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           // Call the layoutSubviews() function when the cell is first created
           layoutSubviews()
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
       }
   }
