//
//  ViewController.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupStyling()
        setupSubviews()
        setupObservers()
        setupTargets()
    }
    
    func setupStyling() {
        
    }
    
    func setupSubviews() {

    }
    
    func bindViewModel() {
        
    }
    
    func setupObservers() {
        
    }
    
    func setupTargets() {
        
    }
}
