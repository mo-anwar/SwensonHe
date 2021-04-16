//
//  CurrencyListViewModel.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrencyListViewModel: ViewModel {
    
    struct Output {
        let dataSource: Driver<[Rate]>
    }
    
    private let dataSource: BehaviorRelay<[Rate]>
    
    private(set) var output: Output!
    
    init(data: [Rate]) {
        dataSource = BehaviorRelay(value: data)
        super.init()
        self.output = Output(dataSource: self.dataSource.asDriver(onErrorJustReturn: []))
    }
}
