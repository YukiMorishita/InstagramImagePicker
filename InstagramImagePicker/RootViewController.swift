//
//  RootViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: - Properties
    
    let pickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Picker", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleShowPicker), for: .touchUpInside)
        return button
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    // MARK: - Setup
    
    fileprivate func setup() {
        view.addSubview(pickerButton)
        
        pickerButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        pickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - Action Handling
    
    @objc func handleShowPicker() {
        var config = InstagramImagePickerConfiguration()
        config.startOnScreen = .library
        config.screens = [.library, .photo, .video]
        
        let pickerVC = InstagramImagePickerViewController(configuration: config)
        
        let navVC = UINavigationController(rootViewController: pickerVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.tintColor = .black
        navVC.navigationBar.isTranslucent = false
        
        present(navVC, animated: true, completion: nil)
    }
}
