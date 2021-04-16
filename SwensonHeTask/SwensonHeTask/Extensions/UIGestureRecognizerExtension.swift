//
//  UIGestureRecognizerExtension.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit

extension UIGestureRecognizer {
    func handler(_ closure: @escaping () -> ()) {
        objc_removeAssociatedObjects(self)
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke))
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
