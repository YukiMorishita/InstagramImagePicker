//
//  VideoViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, PermissionCheckable {
    
    // MARK: - Properties
    
    private let videoCaptureManager = VideoCaptureManager()
    
    private let v = CameraView(cameraMode: .video)
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.delegate = self
    }
    
    deinit {
        print("VideoViewController -> deinit")
    }
    
    // MARK: - Camera
    
    public func startCamera() {
        doAfterPermissionCheck { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.videoCaptureManager.startCamera(with: strongSelf.v.previewContainerView) {
                DispatchQueue.main.async {
                    strongSelf.v.shootButton.isEnabled = true
                    UIView.animate(withDuration: 0.3) {
                        strongSelf.v.blurView.alpha = 0.0
                    }
                }
            }
        }
    }
    
    public func stopCamera() {
        videoCaptureManager.stopCamera()
        
        UIView.animate(withDuration: 0.3) {
            self.v.blurView.alpha = 1.0
        }
    }
}

extension VideoViewController: CameraViewDelegate {
    
    func didFlip() {
        
    }
    
    func didFlash() {}
    
    func didShoot() {
        
    }
}
