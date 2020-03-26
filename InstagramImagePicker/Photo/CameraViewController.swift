//
//  CameraViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, PermissionCheckable {
    
    // MARK: - Properties
    
    private let photoCaptureManager = PhotoCaptureManager()
    
    private let v = CameraView(cameraMode: .photo)
    
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
        print("CameraViewController -> deinit")
    }
    
    // MARK: - Camera
    
    public func startCamera() {
        doAfterPermissionCheck { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.photoCaptureManager.startCamera(with: strongSelf.v.previewContainerView, completion: {
                DispatchQueue.main.async {
                    strongSelf.v.shootButton.isEnabled = true
                    
                    UIView.animate(withDuration: 0.3) {
                        strongSelf.v.blurView.alpha = 0.0
                    }
                }
            })
        }
    }
    
    public func stopCamera() {
        photoCaptureManager.stopCamera()
        
        UIView.animate(withDuration: 0.3) {
            self.v.blurView.alpha = 1.0
        }
    }
    
    fileprivate func refreshFlashButtonImage() {
        let flashImage = photoCaptureManager.currentFlashMode.flashImage()
        v.flashButton.setImage(flashImage, for: .normal)
    }
    
    fileprivate func flipImage(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, true, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.rotate(by: CGFloat(Double.pi * 2.0))
        context?.translateBy(x: 0, y: -image.size.width)
        context?.scaleBy(x: image.size.height / image.size.width, y: image.size.width / image.size.height)
        context?.draw(image.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension CameraViewController: CameraViewDelegate {
    
    func didFlip() {
        photoCaptureManager.flipCamera()
    }
    
    func didFlash() {
        photoCaptureManager.updateFlashMode()
        refreshFlashButtonImage()
    }
    
    func didShoot() {
        photoCaptureManager.shoot { (imageData) in
            // Captured photo
            guard var photoImage = UIImage(data: imageData) else {
                return
            }
            
            // Flip image if taken form the front camera.
            if self.photoCaptureManager.isDevicePositionToFront() {
                photoImage = self.flipImage(photoImage)
            }
            
            self.photoCaptureManager.stopCamera()
            
            UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil)
            
            DispatchQueue.main.async {
                // Prevent from tapping multiple times in a row
                self.v.shootButton.isEnabled = false
            }
        }
    }
}
