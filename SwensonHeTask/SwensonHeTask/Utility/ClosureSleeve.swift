//
//  ClosureSleeve.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import Foundation

@objc class ClosureSleeve: NSObject {
    let closure: () -> Void
    
    init (_ closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    @objc func invoke() {
        closure()
    }
}
