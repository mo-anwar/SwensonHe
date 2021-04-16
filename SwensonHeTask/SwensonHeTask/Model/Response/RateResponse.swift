//
//  RateResponse.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import Foundation

struct RateResponse: Codable {
    let success: Bool?
    let timestamp: Int?
    let base: String?
    let rates: [String: Double]?
}
