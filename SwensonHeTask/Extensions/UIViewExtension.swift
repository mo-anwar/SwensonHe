//
//  UIViewExtension.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import UIKit
import MBProgressHUD

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        view.backgroundColor = .clear
        addSubview(view)
        view.pinAllEdges()
    }
}

enum Edge {
    case safeAreaTop(CGFloat)
    case top(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case bottom(CGFloat)
    case safeAreaBottom(CGFloat)
}

enum ViewCorners {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var cornerMask: CACornerMask {
        switch self {
        case .topLeft:
            return .layerMinXMinYCorner
        case .topRight:
            return .layerMaxXMinYCorner
        case .bottomLeft:
            return .layerMinXMaxYCorner
        case .bottomRight:
            return .layerMaxXMaxYCorner
        }
    }
}

extension UIView {
    
    func round(corners: [ViewCorners], radius: CGFloat) {
        layer.cornerRadius = radius
        var maskedCorners: CACornerMask = []
        corners.forEach {
            maskedCorners.insert($0.cornerMask)
        }
        layer.maskedCorners = maskedCorners
    }
    
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
    
    static func loadFromNib(with owner: Any? = nil) -> Self {
        
        let nib = UINib(nibName: "\(self)", bundle: nil)
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
        
    }
    
    func attachTapGesture(_ handler: @escaping () -> ()) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.handler(handler)
        addGestureRecognizer(tapGesture)
    }
    
    func showActivityIndicator(isUserInteractionEnabled: Bool) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.isUserInteractionEnabled = !isUserInteractionEnabled
        hud.restorationIdentifier = "activityIndicator"
    }
    
    func hideActivityIndicator() {
        for subview in subviews where subview.restorationIdentifier == "activityIndicator" {
            guard let hud = subview as? MBProgressHUD else { return }
            hud.hide(animated: true)
        }
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }

    enum GradientDirection {
        case leftToRight, rightToLeft, topToBottom, bottomToTop
        case topLeftToBottomRight, bottomRightToTopLeft, topRightToBottomLeft, bottomLeftToTopRight
    }
    
    func setGradientBackground(colors: UIColor..., direction: GradientDirection, cornerRadius: CGFloat = 0, maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        setGradientBackground(colors: colors, direction: direction, cornerRadius: cornerRadius)
    }
    
    func setGradientBackground(colors: [UIColor], direction: GradientDirection, cornerRadius: CGFloat = 0, maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.maskedCorners = maskedCorners
        gradientLayer.cornerRadius = cornerRadius
        
        switch direction {
            case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .rightToLeft:
                gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
            case .topToBottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            case .bottomToTop:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            case .topLeftToBottomRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .bottomRightToTopLeft:
                gradientLayer.startPoint = CGPoint(x: 1, y: 1)
                gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            case .topRightToBottomLeft:
                gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .bottomLeftToTopRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        gradientLayer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//Constraints Helpers
extension UIView {
    
    func constraint(block: (UIView) -> ()) {
        translatesAutoresizingMaskIntoConstraints = false
        block(self)
    }
    
    @discardableResult func safeAreaTop(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = topAnchor.constraint(equalTo: constraintToView.safeAreaLayoutGuide.topAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func top(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = topAnchor.constraint(equalTo: constraintToView.topAnchor, constant: padding)
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func topToBottom(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func topToCenterY(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.centerYAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func leading(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = leadingAnchor.constraint(equalTo: constraintToView.leadingAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func leadingToTrailing(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func leadingToCenterX(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func trailing(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = trailingAnchor.constraint(equalTo: constraintToView.trailingAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func bottom(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = bottomAnchor.constraint(equalTo: constraintToView.bottomAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func safeAreaBottom(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = bottomAnchor.constraint(equalTo: constraintToView.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func centerX(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = centerXAnchor.constraint(equalTo: constraintToView.centerXAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func centerY(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = centerYAnchor.constraint(equalTo: constraintToView.centerYAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func height(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func width(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func height(multiplier: CGFloat, constant: CGFloat = 0, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = heightAnchor.constraint(equalTo: constraintToView.heightAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func width(multiplier: CGFloat, constant: CGFloat = 0, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = widthAnchor.constraint(equalTo: constraintToView.widthAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
        
    }
    
    func pin(edges: Edge..., toView view: UIView? = nil) {
        
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for edge in edges {
            switch edge {
            case .safeAreaTop(let padding):
                safeAreaTop(padding, toView: constraintToView)
            case .top(let padding):
                top(padding, toView: constraintToView)
            case .leading(let padding):
                leading(padding, toView: constraintToView)
            case .trailing(let padding):
                trailing(padding, toView: constraintToView)
            case .bottom(let padding):
                bottom(padding, toView: constraintToView)
            case .safeAreaBottom(let padding):
                safeAreaBottom(padding, toView: constraintToView)
            }
        }
    }
    
    func pinAllEdges(padding: CGFloat = 0, toView view: UIView? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let view = view {
            top(padding, toView: view)
            leading(padding, toView: view)
            trailing(padding, toView: view)
            bottom(padding, toView: view)
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            top(padding, toView: superview)
            leading(padding, toView: superview)
            trailing(padding, toView: superview)
            bottom(padding, toView: superview)
        }
    }
    
}
