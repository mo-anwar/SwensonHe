//
//  ConvertorViewController.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ConvertorViewController: ViewController {
    
    @IBOutlet private weak var baseCurrencyTestField: UITextField!
    @IBOutlet private weak var selectedCurrencyLabel: UILabel!
    @IBOutlet private weak var baseCurrencyFlagLabel: UILabel!
    
    private let viewModel: ConvertorViewModel
    
    init(viewModel: ConvertorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.setGradientBackground(colors: [.rgba(19, 99, 170, 1), .rgba(20, 63, 103, 1)], direction: .topToBottom)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        baseCurrencyTestField.rx.controlEvent(.editingChanged).withLatestFrom(baseCurrencyTestField.rx.text.orEmpty)
            .bind(to: viewModel.input.baseItemChanged)
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .dataSource
            .drive { [weak self] selected, base in
                guard let self = self else { return }
                self.baseCurrencyTestField.text = base.value
                self.baseCurrencyFlagLabel.text = base.code
                self.selectedCurrencyLabel.text = "\(selected.value) \(selected.code)"
            }
            .disposed(by: disposeBag)
        
    }
}

extension ConvertorViewController {
    static func create(selectedCurrencey: Rate, baseCurrencey: Rate) -> ConvertorViewController {
        let viewModel = ConvertorViewModel(selectedCurrencey: selectedCurrencey, baseCurrencey: baseCurrencey)
        let controller = ConvertorViewController(viewModel: viewModel)
        controller.loadViewIfNeeded()
        return controller
    }
}
