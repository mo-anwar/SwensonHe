//
//  ConvertorViewModel.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ConvertorViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let baseItemChanged: AnyObserver<String>
    }
    
    struct Output {
        let dataSource: Driver<(Rate, Rate)>
    }
    
    // MARK: - Input Properties
    private let changeBaseCurrencyItem = ReplaySubject<String>.create(bufferSize: 1)
    private(set) var input: Input!
    
    // MARK: - output Properties
    private let dataSource: BehaviorRelay<(Rate, Rate)>
    private let selectedCurrencey: Rate
    private(set) var output: Output!
    
    init(selectedCurrencey: Rate, baseCurrencey: Rate) {
        
        self.dataSource = BehaviorRelay<(Rate, Rate)>(value: (selectedCurrencey, baseCurrencey))
        self.selectedCurrencey = selectedCurrencey
        super.init()
        self.input = Input(baseItemChanged: changeBaseCurrencyItem.asObserver())
        self.output = Output(dataSource: dataSource.asDriver())
        changeBaseCurrency()
    }
    
    private func changeBaseCurrency() {
        changeBaseCurrencyItem
            .debug()
            .withLatestFrom(dataSource) { value, dataSource in
                return (value, dataSource)
            }
            .map { value, dataSource -> (Rate, Rate) in
                var base = Rate(code: dataSource.1.code, value: value.double)
                let selected = Rate(code: dataSource.0.code, value: value.double * self.selectedCurrencey.value.double)
                base.value = value
                return (selected, base)
            }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)
    }
    
}
