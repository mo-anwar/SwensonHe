//
//  UIColorExtension.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit

extension UIColor {
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
}
