//
//  CurrencyListViewController.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/15/21.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

final class HomeViewController: ViewController {
    
    @IBOutlet private weak var baseCurrencyFlagImageView: UIImageView!
    @IBOutlet private weak var baseCurrencyNameLabel: UILabel!
    @IBOutlet fileprivate weak var currencyListTableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    
    private let viewModel: HomeViewModel
    private var refreshControl = UIRefreshControl()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyListTableView.refreshControl = refreshControl
        Observable
            .just(())
            .concat(Observable.never())
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        baseCurrencyFlagImageView.round(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radius: baseCurrencyFlagImageView.frame.height / 2)
        headerView.setGradientBackground(colors: [.rgba(19, 99, 170, 1), .rgba(20, 63, 103, 1)], direction: .topToBottom)
        setupTableView()
    }
    
    private func setupTableView() {
        currencyListTableView.register(cell: CurrencyCell.self)
        currencyListTableView.rowHeight = 90
    }
    // swiftlint:disable function_body_length
    override func bindViewModel() {
        super.bindViewModel()
        baseCurrencyFlagImageView.onTap { [weak self] in
            guard let self = self else { return }
            Observable
                .just(())
                .concat(Observable.never())
                .bind(to: self.viewModel.input.changeBaseCurrencyTrigger)
                .disposed(by: self.disposeBag)
        }
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.input.reloadItems)
            .disposed(by: disposeBag)
        
        currencyListTableView
            .rx
            .itemSelected
            .bind(to: viewModel.input.selectedItemTrigger)
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .dataSource
            .drive(currencyListTableView.rx.items(cellIdentifier: CurrencyCell.className, cellType: CurrencyCell.self)) { _, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .base
            .drive { [weak self] item in
                guard let self = self else { return }
                self.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .isLoading
            .drive(onNext: { [weak self] isLoading, isUserInteractionEnabled in
                guard let self = self else { return }
                if isLoading {
                    self.view.showActivityIndicator(isUserInteractionEnabled: isUserInteractionEnabled)
                } else {
                    self.view.hideActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlert(with: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .isRefreshing
            .drive(onNext: { [weak self] isRefreshing in
                guard let self = self else { return }
                if !isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .didTapchangeBaseCurrency
            .drive(onNext: { [weak self] rates in
                guard let self = self else { return }
                let currencyListViewController = CurrencyListViewController.create(data: rates)
                currencyListViewController
                    .rx
                    .baseCurrencySelected
                    .concat(Observable.never())
                    .bind(to: self.viewModel.input.baseItemChanged)
                    .disposed(by: self.disposeBag)
                self.push(currencyListViewController)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .didSelectedItem
            .drive(onNext: { [weak self] dataSource in
                guard let self = self else { return }
                let convertorViewController = ConvertorViewController.create(selectedCurrencey: dataSource.0, baseCurrencey: dataSource.1)
                self.push(convertorViewController)
            })
            .disposed(by: disposeBag)
    }
    
    private func configure(item: Rate) {
        baseCurrencyFlagImageView.image = item.flag
        baseCurrencyNameLabel.text = item.code
    }
}

extension HomeViewController {
    static func create() -> HomeViewController {
        let currencyRepository = CurrencyRepository()
        let viewModel = HomeViewModel(currencyRepository: currencyRepository)
        let controller = HomeViewController(viewModel: viewModel)
        controller.loadViewIfNeeded()
        return controller
    }
}
