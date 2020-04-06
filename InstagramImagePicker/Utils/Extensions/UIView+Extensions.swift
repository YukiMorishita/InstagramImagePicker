//
//  UIView+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fillSuperview(insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = self.superview else {
            return
        }
        
        topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right).isActive = true
    }
    
    func centerInSuperview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = self.superview else {
            return
        }
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
}
