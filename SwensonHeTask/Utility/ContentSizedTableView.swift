//
//  ContentSizedTableView.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21./

import UIKit

class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
