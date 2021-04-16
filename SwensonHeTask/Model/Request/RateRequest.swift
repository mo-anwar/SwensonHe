//
//  RateRequest.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import Foundation

struct RateRequest: Encodable {
    
    let accessKey: String
    
    enum CodingKeys: String, CodingKey {
        case accessKey = "access_key"
    }
}
