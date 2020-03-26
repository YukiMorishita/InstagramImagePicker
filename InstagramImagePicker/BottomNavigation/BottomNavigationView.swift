//
//  BottomNavigationView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class BottomNavigationView: UIView {
    
    // MARK: - Properties
    
    let menu: BottomNavigationMenu = {
        let m = BottomNavigationMenu()
        return m
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.scrollsToTop = false
        sv.bounces = false
        sv.clipsToBounds = false
        return sv
    }()
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(menu)
        addSubview(scrollView)
        
        menu.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        
        scrollView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: menu.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
