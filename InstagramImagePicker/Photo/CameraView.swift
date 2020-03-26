//
//  CameraView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol CameraViewDelegate: class {
    func didFlip()
    func didFlash()
    func didShoot()
}

class CameraView: UIView {
    
    enum CameraMode {
        case photo
        case video
    }
    
    // Properties
    
    weak var delegate: CameraViewDelegate?
    
    var cameraMode: CameraMode!
    
    let focusView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.backgroundColor = .clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.alpha = 0.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.rgb(red: 153, green: 153, blue: 153).cgColor
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: effect)
        vev.alpha = 0.0
        return vev
    }()
    
    let previewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let hudContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let flipButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "flip")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleFlip), for: .touchUpInside)
        return button
    }()
    
    let flashButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "flash_auto")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleFlash), for: .touchUpInside)
        return button
    }()
    
    let shootButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleShoot), for: .touchUpInside)
        return button
    }()
    
    let timeElapsedLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    let progressBar: UIProgressView = {
        let pv = UIProgressView()
        pv.trackTintColor = .clear
        pv.tintColor = .systemRed
        return pv
    }()
    
    // MARK: - Initializer
    
    convenience init(cameraMode: CameraMode) {
        self.init(frame: .zero)
        self.cameraMode = cameraMode
        
        setupViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(previewContainerView)
        addSubview(hudContainerView)
        addSubview(flipButton)
        hudContainerView.addSubview(shootButton)
        
        previewContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: UIScreen.main.bounds.width)
        
        hudContainerView.anchor(top: previewContainerView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        flipButton.anchor(top: nil, left: nil, bottom: previewContainerView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: 42, height: 42)
        
        shootButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 84, height: 84)
        shootButton.centerXAnchor.constraint(equalTo: hudContainerView.centerXAnchor).isActive = true
        shootButton.centerYAnchor.constraint(equalTo: hudContainerView.centerYAnchor).isActive = true
        
        let image = UIImage(named: cameraMode == .photo ? "photo_capture" : "video_capture")?.withRenderingMode(.alwaysOriginal)
        shootButton.setImage(image, for: .normal)
        
        if cameraMode == .photo {
            addSubview(flashButton)
            
            flashButton.anchor(top: nil, left: leftAnchor, bottom: previewContainerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: 42, height: 42)
        } else {
            addSubview(timeElapsedLabel)
            addSubview(progressBar)
            
            timeElapsedLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
            
            progressBar.anchor(top: previewContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        }
        
        addSubview(blurView)
        
        blurView.anchor(top: previewContainerView.topAnchor, left: previewContainerView.leftAnchor, bottom: previewContainerView.bottomAnchor, right: previewContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    // MARK: - Action Handling
    
    @objc func handleFlip() {
        delegate?.didFlip()
    }
    
    @objc func handleFlash() {
        delegate?.didFlash()
    }
    
    @objc func handleShoot() {
        delegate?.didShoot()
    }
}
