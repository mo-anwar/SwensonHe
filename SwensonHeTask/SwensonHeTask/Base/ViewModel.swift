//
//  ViewModel.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import Foundation
import RxSwift

protocol ViewModelType: class {
    
    associatedtype Input
    associatedtype Output
    
    var input: Input! { get }
    var output: Output! { get }
}

class ViewModel {
    let disposeBag = DisposeBag()
    
    var didReceieveErrorMessage: ((String) -> Void)?
    var showActivityIndicator: ((Bool) -> Void)?
    var hideActivityIndicator: (() -> Void)?
}
