//
//  HomeViewModel.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let reloadItems: AnyObserver<Void>
        let viewDidLoad: AnyObserver<Void>
        let changeBaseCurrencyTrigger: AnyObserver<Void>
        let baseItemChanged: AnyObserver<Rate>
        let selectedItemTrigger: AnyObserver<IndexPath>
    }
    
    struct Output {
        let isLoading: Driver<ActivityIndicatorState>
        let error: Driver<Error>
        let dataSource: Driver<[Rate]>
        let didTapchangeBaseCurrency: Driver<[Rate]>
        let base: Driver<Rate>
        let isRefreshing: Driver<Bool>
        let didSelectedItem: Driver<(Rate, Rate)>
    }
    
    // MARK: - Input Properties
    private let viewDidLoad = PublishSubject<Void>()
    private let reloadItems = PublishSubject<Void>()
    private let changeBaseCurrencyItem = PublishSubject<Void>()
    private let selectedItemTrigger = PublishSubject<IndexPath>()
    
    private(set) var input: Input!
    
    // MARK: - output Properties
    private let activityIndicatorTracker = ActivityIndicatorTracker()
    private let errorTracker = ErrorTracker()
    private let dataSource = BehaviorRelay<[Rate]>(value: [])
    private let base = PublishSubject<Rate>()
    private let isRefreshing = PublishSubject<Bool>()
    private(set) var output: Output!
    
    private let response = PublishSubject<RateResponse>()
    private let currencyRepository: CurrencyRepositoryProtocol
    
    init(currencyRepository: CurrencyRepositoryProtocol) {
        self.currencyRepository = currencyRepository
        super.init()
        
        loadContent()
        reloadContent()
        setupDataSource()
        setupBase()
        observeBaseChange()
        self.input = Input(
            reloadItems: reloadItems.asObserver(),
            viewDidLoad: viewDidLoad.asObserver(),
            changeBaseCurrencyTrigger: self.changeBaseCurrencyItem.asObserver(),
            baseItemChanged: base.asObserver(),
            selectedItemTrigger: selectedItemTrigger.asObserver()
        )
        
        let didTapchangeBaseCurrency = self.didTapchangeBaseCurrency()
        let didSelectedItem = self.didSelectedItem()
        
        self.output = Output(
            isLoading: activityIndicatorTracker.asDriver(),
            error: errorTracker.asDriver(),
            dataSource: self.dataSource.asDriver(onErrorJustReturn: []),
            didTapchangeBaseCurrency: didTapchangeBaseCurrency,
            base: base.asDriverOnErrorJustComplete(),
            isRefreshing: isRefreshing.asDriver(onErrorJustReturn: false),
            didSelectedItem: didSelectedItem
        )
    }
    
    private func loadContent() {
        viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<RateResponse> in
                guard let self = self else { return .empty() }
                return self.currencyRepository
                    .rateList()
                    .trackActivity(on: self.activityIndicatorTracker, isUserInteractionEnabled: true)
                    .trackError(self.errorTracker)
                    .catchErrorJustComplete()
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isRefreshing.onNext(false)
            })
            .bind(to: response)
            .disposed(by: disposeBag)
    }
    
    private func reloadContent() {
        reloadItems
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isRefreshing.onNext(true)
            })
            .delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .bind(to: viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        response
            .map { response -> [Rate] in
                var rates = [Rate]()
                response.rates?.sorted(by: <).forEach { key, value in
                    rates.append(Rate(code: key, value: value))
                }
                return rates
            }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)
    }
    
    private func setupBase() {
        response
            .map { response -> Rate in
                var rates = [Rate]()
                response.rates?.sorted(by: <).forEach { key, value in
                    rates.append(Rate(code: key, value: value))
                }
                return rates.first(where: { $0.code == response.base })!
            }
            .bind(to: self.base)
            .disposed(by: disposeBag)
    }
    
    private func didTapchangeBaseCurrency() -> Driver<[Rate]> {
        changeBaseCurrencyItem
            .withLatestFrom(dataSource) {_, dataSource in
                return (dataSource)
            }
            .asDriverOnErrorJustComplete()
    }
    
    private func observeBaseChange() {
        base
            .withLatestFrom(dataSource) { base, dataSource in
                return (base, dataSource)
            }
            .map { rate, dataSource in
                let convertedData: [Rate] = dataSource.map {
                    let rate = Rate(code: $0.code, value: Double($0.value.double / rate.value.double))
                    return rate
                }
                return convertedData
            }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)
    }
    
    private func didSelectedItem() -> Driver<(Rate, Rate)> {
        selectedItemTrigger
            .withLatestFrom(dataSource) { selectedItemTrigger, dataSource in
                return (selectedItemTrigger, dataSource)
            }
            .map { selectedIndex, dataSource -> Rate in
                return dataSource[selectedIndex.row]
            }
            .withLatestFrom(base) { selected, base in
                let newbase = Rate(code: base.code, value: 1)
                return (selected, newbase)
            }
            .asDriverOnErrorJustComplete()
    }
}
