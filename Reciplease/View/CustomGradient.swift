//
//  CustomGradient.swift
//  Reciplease
//
//  Created by Guillaume Bourlart on 12/12/2022.
//

import Foundation
import QuartzCore
import UIKit

class CustomGradient: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradientLayer()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientLayer()
    }

    func configureGradientLayer() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(named: "Color")!.cgColor, UIColor(named: "Color1")!.cgColor]
    }
}
