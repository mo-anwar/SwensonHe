//
//  CurrencyCell.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/15/21.
//

import UIKit

final class CurrencyCell: TableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var currencyRateLabel: UILabel!
    @IBOutlet private weak var currencyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
    private func setupImageView() {
        flagImageView.round(corners: [.topLeft, .bottomLeft, .topRight, .bottomRight], radius: flagImageView.frame.height / 2)
    }
    
    func configure(item: Rate) {
        currencyNameLabel.text = item.code
        currencyRateLabel.text = item.value
        flagImageView.image = item.flag
    }
    
    func configure(code: String, flag: UIImage) {
        currencyNameLabel.text = code
        flagImageView.image = flag
    }
}
