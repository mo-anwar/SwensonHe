//
//  TableViewCell.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit
import RxSwift

class TableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
        setupSubviews()
        setupLocalization()
    }
    
    func setupStyling() {
        
    }
    
    func setupSubviews() {
        
    }
    
    func setupLocalization() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
