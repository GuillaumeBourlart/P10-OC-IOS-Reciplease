//
//  CustomLabel.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 12/12/2022.
//

import UIKit

class CustomLabel: UILabel {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
  
    
       

}
