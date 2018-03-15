//
//  Colors.swift
//  MemoryCard
//
//  Created by Yurii Tsymbala on 14.03.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct Backgrounds {
        static var darkOrange: UIColor  { return UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0) }
        static var mediumOrange: UIColor { return UIColor(red:0.95, green:0.66, blue:0.22, alpha:1.0) }
        static var lightOrange: UIColor  { return UIColor(red:0.97, green:0.76, blue:0.40, alpha:1.0) }
        static var lightBlack: UIColor { return UIColor(red: 0.2298397148, green: 0.2734779793, blue: 0.2721715065, alpha: 1) }
        static var mediumGray: UIColor { return UIColor(red:0.75, green:0.61, blue:0.37, alpha:1.0) }
        static var lightRed: UIColor { return UIColor(red:0.69, green:0.25, blue:0.04, alpha:1.0)}
        static var darkBlue: UIColor { return UIColor(red:0.16, green:0.32, blue:0.79, alpha:1.0)}
        static var darkYellow: UIColor { return UIColor(red:0.90, green:0.85, blue:0.52, alpha:0.6) }
        static var mainYellow: UIColor { return UIColor(red:1.00, green:0.88, blue:0.34, alpha:1.0)}
    }
    
    struct Button {
        static var backgroundColor: UIColor { return UIColor.cyan }
        static var titleColor: UIColor { return white }
    }
}

