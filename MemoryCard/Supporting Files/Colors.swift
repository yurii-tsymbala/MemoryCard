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
    
    static var darkModeratePink: UIColor { return UIColor(red:0.60, green:0.20, blue:0.40, alpha:1.0) }
    
    struct Backgrounds {
        static var GrayLighter: UIColor  { return UIColor(red:0.26, green:0.30, blue:0.33, alpha:1.0) }
        static var GrayLight: UIColor  { return UIColor(red:0.15, green:0.17, blue:0.18, alpha:1.0) }
        static var GrayDark: UIColor  { return UIColor(red:0.08, green:0.09, blue:0.11, alpha:1.0) }
    }
    
    struct Font {
        static var White: UIColor { return UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0) }
        static var Gray: UIColor { return UIColor(red:0.39, green:0.40, blue:0.41, alpha:1.0) }
    }
    
    struct TabBar {
        static var tint: UIColor { return darkModeratePink }
        static var barTint: UIColor { return black }
    }
    
    struct Button {
        static var backgroundColor: UIColor { return darkModeratePink }
        static var titleColor: UIColor { return white }
    }
    
    struct TextFieldBackGrounds {
        static var BackgroundForFalse: UIColor { return UIColor(red:0.75, green:0.10, blue:0.10, alpha:1.0) }
    }
}

