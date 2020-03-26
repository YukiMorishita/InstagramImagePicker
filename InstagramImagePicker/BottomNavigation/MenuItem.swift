//
//  MenuItem.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class MenuItem: UIView {
    
    // MARK: - Properties
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let button: UIButton = {
        let b = UIButton(type: .system)
        return b
    }()
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        setupViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(textLabel)
        addSubview(button)
        
        textLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func select() {
        textLabel.textColor = .black
    }
    
    func deselect() {
        textLabel.textColor = .lightGray
    }
}
