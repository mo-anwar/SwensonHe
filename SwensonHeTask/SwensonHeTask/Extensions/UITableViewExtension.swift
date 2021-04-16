//
//  UITableViewExtension.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type) {
        register(headerFooter.nib, forHeaderFooterViewReuseIdentifier: headerFooter.className)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
         guard let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else { fatalError("DequeueReusableCell failed while casting") }
        return cell
    }
}
