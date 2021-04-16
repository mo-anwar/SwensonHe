//
//  NetworkLayer.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import Foundation
import Alamofire
import RxSwift

class NetworkLayer {
    
    class func request<T: Decodable>(
        _ request: URLRequestConvertible,
        decodedTo type: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension ObservableType {
    static func createFromResult<E: Error>(_ function: @escaping (@escaping (Result<Element, E>) -> Void) -> Void) -> Observable<Element> {
        return Observable.create { observer in
            function { result in
                switch result {
                case .success(let element):
                    observer.onNext(element)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
