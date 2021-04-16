//
//  String.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit

extension String {
    var double: Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
}
