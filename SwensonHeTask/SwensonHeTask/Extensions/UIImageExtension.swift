//
//  UIImageExtension.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit

extension UIImageView {
    
    func onTap(_ closure: @escaping () -> Void) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.handler(closure)
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGestureRecognizer)
    }
}
