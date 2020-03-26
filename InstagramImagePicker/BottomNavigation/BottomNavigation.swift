//
//  BottomNavigation.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol BottomNavigationDelegate: class {
    func didSelect(for vc: UIViewController)
}

class BottomNavigation: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: BottomNavigationDelegate?
        
    var controllers: [UIViewController] = [] { didSet { reload() } }
    var currentPage: Int = 0
    
    var currentController: UIViewController {
        return controllers[currentPage]
    }
    
    let v = BottomNavigationView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.scrollView.delegate = self
    }
    
    private func reload() {
        let viewWidth: CGFloat = UIScreen.main.bounds.width
        
        for (index, controller) in controllers.enumerated() {
            // Remove controller
            controller.willMove(toParent: self)
            addChild(controller)
            
            // Add controller
            let x: CGFloat = CGFloat(index) * viewWidth
            v.scrollView.addSubview(controller.view)
            controller.didMove(toParent: self)
            
            controller.view.anchor(top: v.scrollView.topAnchor, left: v.scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: x, paddingBottom: 0, paddingRight: 0, width: viewWidth, height: 0)
            controller.view.heightAnchor.constraint(equalTo: v.scrollView.heightAnchor).isActive = true
            
            let scrollableWidth: CGFloat = CGFloat(controllers.count) * CGFloat(viewWidth)
            v.scrollView.contentSize = CGSize(width: scrollableWidth, height: 0)
            
            // Reset menu items
            v.menu.items.removeAll()
            
            // Set menu items
            for (index, controller) in controllers.enumerated() {
                let menuItem = MenuItem()
                menuItem.textLabel.text = controller.title?.capitalized
                menuItem.button.tag = index
                menuItem.button.addTarget(self, action: #selector(handleSelectMenuItem), for: .touchUpInside)
                v.menu.items.append(menuItem)
            }
            
            let currentMenuItem = v.menu.items[currentPage]
            currentMenuItem.select()
            v.menu.refreshMenuItems()
        }
    }
    
    public func startOnPage(_ page: Int) {
        currentPage = page
        
        let x = CGFloat(page) * UIScreen.main.bounds.width
        v.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        
        for menuItem in v.menu.items {
            menuItem.deselect()
        }
        
        let currentMenuItem = v.menu.items[currentPage]
        currentMenuItem.select()
    }
    
    public func selectPage(_ page: Int) {
        guard page != currentPage && page >= 0 && page < controllers.count else {
            return
        }
        
        currentPage = page
        
        for (index, menuItem) in v.menu.items.enumerated() {
            if index == page {
                menuItem.select()
            } else {
                menuItem.deselect()
            }
        }
        
        let vc = controllers[page]
        delegate?.didSelect(for: vc)
    }
    
    // MARK: - Action Handling
    
    @objc private func handleSelectMenuItem(_ button: UIButton) {
        showPage(button.tag)
    }
    
    private func showPage(_ page: Int, animated: Bool = true) {
        let x = CGFloat(page) * UIScreen.main.bounds.width
        v.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
        selectPage(page)
    }
}

// MARK: - UIScrollViewDelegate

extension BottomNavigation: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !v.menu.items.isEmpty {
            let menuIndex = (targetContentOffset.pointee.x + v.frame.width) / v.frame.width
            let selectedIndex = Int(round(menuIndex)) - 1
            if selectedIndex != currentPage {
                self.selectPage(selectedIndex)
            }
        }
    }
}
