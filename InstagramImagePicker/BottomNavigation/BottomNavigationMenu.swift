//
//  BottomNavigationMenu.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class BottomNavigationMenu: UIView {
    
    // MARK: Properties
    
    private var didSetConstraints = false
    
    public var items: [MenuItem] = []
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        
        clipsToBounds = true
    }
    
    // MARK: - Setup
    
    public func setup() {
        let menuItemWidth: CGFloat = UIScreen.main.bounds.width / CGFloat(items.count)
        var previousMenuItem: MenuItem?
        
        // Set constraints
        for menuItem in items {
            addSubview(menuItem)
            
            menuItem.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: menuItemWidth, height: 0)
            
            if let _previousMenuItem = previousMenuItem {
                menuItem.leftAnchor.constraint(equalTo: _previousMenuItem.rightAnchor).isActive = true
            } else {
                menuItem.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            }
            
            previousMenuItem = menuItem
        }
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !didSetConstraints {
            setup()
        }
        
        didSetConstraints = true
    }
    
    public func refreshMenuItems() {
        didSetConstraints = false
        updateConstraints()
    }
}
