//
//  Instructions.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 15/12/2022.
//

import Foundation
import UIKit
import WebKit
import SafariServices

// This class is responsible for displaying the web page with the instructions for a recipe
class InstructionsViewController: UIViewController{
    // The web view for displaying the instructions
    @IBOutlet weak var instructionsWebKit: WKWebView!
    
    // The URL string for the instructions page
    var link : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform any additional setup after loading the view.
    }
    
}
