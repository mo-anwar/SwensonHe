//
//  RuntimeError.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
import Foundation

enum RuntimeError: Error, LocalizedError {
    
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return nil
        }
    }
}
