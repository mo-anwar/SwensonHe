//
//  Rate.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import FlagKit

struct Rate {
    let code: String
    var value: String
    let selected = false
    
    init(code: String, value: Double) {
        self.code = code
        self.value = String(format: "%.3f", value)
    }
    
    var flag: UIImage {
        guard let flag = Flag(countryCode: String(code.prefix(2))) else { return UIImage() }
        return flag.originalImage
    }
}
