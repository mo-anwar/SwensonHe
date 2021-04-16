//
//  Obfuscator.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21..
//

import Foundation

class Obfuscator {
    
    private var accessKeyByteArray: [UInt8] = [57, 48, 51, 101, 100, 51, 98, 53, 55, 102, 51, 100, 56, 102, 53, 99, 54, 101, 52, 52, 102, 56, 52, 102, 101, 101, 49, 100, 54, 53, 98, 99]
    
    var accessKey: String {
        guard let client = String(bytes: accessKeyByteArray, encoding: .utf8) else { return "" }
        return client
    }
}
