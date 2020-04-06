//
//  GridView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

final class GridView: UIView {
    
    // MARK: - Properties
    
    fileprivate let line1 = UIView()
    fileprivate let line2 = UIView()
    fileprivate let line3 = UIView()
    fileprivate let line4 = UIView()
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        
        isUserInteractionEnabled = false
        setupLines()
    }
    
    // MARK: - Setup
    
    fileprivate func setupLines() {
        addSubview(line1)
        addSubview(line2)
        addSubview(line3)
        addSubview(line4)
        
        line1.translatesAutoresizingMaskIntoConstraints = false
        line2.translatesAutoresizingMaskIntoConstraints = false
        line3.translatesAutoresizingMaskIntoConstraints = false
        line4.translatesAutoresizingMaskIntoConstraints = false
        
        let stroke: CGFloat = 0.5
        
        NSLayoutConstraint.activate([
            line1.topAnchor.constraint(equalTo: topAnchor),
            line1.bottomAnchor.constraint(equalTo: bottomAnchor),
            line1.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(-UIScreen.main.bounds.width * 0.33)),
            line1.widthAnchor.constraint(equalToConstant: stroke)
        ])
        
        NSLayoutConstraint.activate([
            line2.topAnchor.constraint(equalTo: topAnchor),
            line2.bottomAnchor.constraint(equalTo: bottomAnchor),
            line2.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(-UIScreen.main.bounds.width * 0.66)),
            line2.widthAnchor.constraint(equalToConstant: stroke)
        ])
        
        NSLayoutConstraint.activate([
            line3.leftAnchor.constraint(equalTo: leftAnchor),
            line3.rightAnchor.constraint(equalTo: rightAnchor),
            line3.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-UIScreen.main.bounds.width * 0.33)),
            line3.heightAnchor.constraint(equalToConstant: stroke)
        ])
        
        NSLayoutConstraint.activate([
            line4.leftAnchor.constraint(equalTo: leftAnchor),
            line4.rightAnchor.constraint(equalTo: rightAnchor),
            line4.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-UIScreen.main.bounds.width * 0.66)),
            line4.heightAnchor.constraint(equalToConstant: stroke)
        ])
        
        let color = UIColor.white.withAlphaComponent(0.6)
        line1.backgroundColor = color
        line2.backgroundColor = color
        line3.backgroundColor = color
        line4.backgroundColor = color
        
        applyShadow(to: line1)
        applyShadow(to: line2)
        applyShadow(to: line3)
        applyShadow(to: line4)
    }
    
    // MARK: - Shadow
    
    fileprivate func applyShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

