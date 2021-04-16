//
//  CurrencyRepository.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import Foundation
import RxSwift

protocol CurrencyRepositoryProtocol {
    func rateList() -> Observable<RateResponse>
}

class CurrencyRepository: CurrencyRepositoryProtocol {
    
    func rateList() -> Observable<RateResponse> {
        let obfuscator = Obfuscator()
        let parameter = RateRequest(accessKey: obfuscator.accessKey)
        let request = CurrencyNetworkRouter.rateList(parameters: parameter)
        
        return .createFromResult { completionHandler in
            return NetworkLayer.request(request, decodedTo: RateResponse.self, completionHandler: completionHandler)
        }
    }
}
