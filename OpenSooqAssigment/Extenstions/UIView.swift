//
//  UIView.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import UIKit
extension UIView{
    struct Constraints {
        var topAnchor:      NSLayoutConstraint?
        var leadingAnchor:  NSLayoutConstraint?
        var bottomAnchor:   NSLayoutConstraint?
        var trailingAnchor: NSLayoutConstraint?
        var widthAnchor:    NSLayoutConstraint?
        var heightAnchor:   NSLayoutConstraint?
        var centerXAnchor:  NSLayoutConstraint?
        var centerYAnchor:  NSLayoutConstraint?
        
        init() {
          topAnchor      = nil
          leadingAnchor  = nil
          bottomAnchor   = nil
          trailingAnchor = nil
          widthAnchor    = nil
          heightAnchor   = nil
          centerXAnchor  = nil
          centerYAnchor  = nil
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var _topAnchor: NSLayoutConstraint?
        var _leadingAnchor: NSLayoutConstraint?
        var _bottomAnchor: NSLayoutConstraint?
        var _trailingAnchor: NSLayoutConstraint?
        var _widthAnchor: NSLayoutConstraint?
        var _heightAnchor: NSLayoutConstraint?
        var _centerXAnchor: NSLayoutConstraint?
        var _centerYAnchor: NSLayoutConstraint?
        var anchorsArr = [NSLayoutConstraint]()

        if let top = top {
            _topAnchor = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchorsArr.append(_topAnchor!)
        }
        
        if let leading = leading {
            _leadingAnchor = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchorsArr.append(_leadingAnchor!)
        }
        
        if let bottom = bottom {
            _bottomAnchor = bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom)
            anchorsArr.append(_bottomAnchor!)
        }
        
        if let trailing = trailing {
            _trailingAnchor = trailingAnchor.constraint(equalTo: trailing, constant: padding.right)
            anchorsArr.append(_trailingAnchor!)
        }
        
        if let centerX = centerX {
            _centerXAnchor = centerXAnchor.constraint(equalTo: centerX, constant: 0)
            anchorsArr.append(_centerXAnchor!)
        }
        
        if let centerY = centerY {
            _centerYAnchor = centerYAnchor.constraint(equalTo: centerY, constant: 0)
            anchorsArr.append(_centerYAnchor!)
        }
        
        if size.width != 0 {
            _widthAnchor = widthAnchor.constraint(equalToConstant: size.width)
            anchorsArr.append(_widthAnchor!)
        }
        
        if size.height != 0 {
            _heightAnchor = heightAnchor.constraint(equalToConstant: size.height)
            anchorsArr.append(_heightAnchor!)
        }
        
        NSLayoutConstraint.activate(anchorsArr)
    }
}
