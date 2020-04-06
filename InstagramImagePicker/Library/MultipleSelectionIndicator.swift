//
//  MultipleSelectionIndicator.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class MultipleSelectionIndicator: UIView {
    
    // MARK: - Properties
    
    private let selectionColor = UIColor.systemBlue
    
    let circle: UIView = {
        let view = UIView()
        return view
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(circle)
        addSubview(numberLabel)
        
        circle.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        circle.layer.cornerRadius = 20 / 2
        
        numberLabel.fillSuperview()
    }
    
    // MARK: - Public Method
    
    public func setNumber(_ number: Int?) {
        numberLabel.isHidden = number == nil
        
        if let number = number {
            circle.backgroundColor = selectionColor
            circle.layer.borderColor = UIColor.clear.cgColor
            circle.layer.borderWidth = 0.0
            numberLabel.text = "\(number)"
        } else {
            circle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            circle.layer.borderColor = UIColor.white.cgColor
            circle.layer.borderWidth = 1.0
            numberLabel.text = ""
        }
    }
}
