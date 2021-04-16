//
//  CurrencyNetworkRouter.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import Foundation
import Alamofire

enum CurrencyNetworkRouter: URLRequestConvertible {
    
    case rateList(parameters: RateRequest)
    
    var method: HTTPMethod {
        switch self {
            
        case .rateList:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .rateList(let parameters):
            return try? parameters.asDictionary()
        }
    }
    
    var url: URL {
        let endpoint: String
        switch self {
        case .rateList:
            endpoint = Constants.CurrencyEndpoints.rateList
        }
        return URL(string: Constants.baseURL)!.appendingPathComponent(endpoint)
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .rateList:
            return URLEncoding.queryString
        }
    }
}
