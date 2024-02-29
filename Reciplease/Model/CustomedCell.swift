//
//  CustomedCell.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 09/12/2022.
//

import Foundation
import UIKit

class CustomedCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.performSegue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performSegue(){
        
    }
    
}
