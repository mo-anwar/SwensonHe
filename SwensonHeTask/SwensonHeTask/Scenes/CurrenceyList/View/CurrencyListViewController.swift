//
//  CurrencyListViewController.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrencyListViewController: ViewController {
    
    @IBOutlet fileprivate weak var currencyListTableView: UITableView!
    
    private let viewModel: CurrencyListViewModel
    
    init(viewModel: CurrencyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Base Currency"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupSubviews() {
        super.setupSubviews()
        setupTableView()
    }
    
    private func setupTableView() {
        currencyListTableView.register(cell: CurrencyCell.self)
        currencyListTableView.rowHeight = 90
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel
            .output
            .dataSource
            .drive(currencyListTableView.rx.items(cellIdentifier: CurrencyCell.className, cellType: CurrencyCell.self)) { _, item, cell in
                cell.configure(code: item.code, flag: item.flag)
            }
            .disposed(by: disposeBag)
        
        currencyListTableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pop()
            })
            .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: CurrencyListViewController {
    
    var baseCurrencySelected: Observable<Rate> {
        base
            .currencyListTableView
            .rx
            .modelSelected(Rate.self)
            .asObservable()
    }
}

extension CurrencyListViewController {
    static func create(data: [Rate]) -> CurrencyListViewController {
        let viewModel = CurrencyListViewModel(data: data)
        let controller = CurrencyListViewController(viewModel: viewModel)
        controller.loadViewIfNeeded()
        return controller
    }
}
