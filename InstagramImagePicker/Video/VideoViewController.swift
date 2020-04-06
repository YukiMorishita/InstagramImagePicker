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
        
        videoCaptureManager.videoRecordingProgress = { [weak self] (progress, timeInterval) in
            self?.updateRecordingState(progress: progress, timeInterval: timeInterval)
        }
        
        v.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFocus))
        v.previewContainerView.addGestureRecognizer(tapGesture)
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
            
            // Reset progress and time elapsed
            strongSelf.resetRecordingState()
        }
    }
    
    public func stopCamera() {
        videoCaptureManager.stopCamera()
        
        UIView.animate(withDuration: 0.3) {
            self.v.blurView.alpha = 1.0
        }
    }
    
    // MARK: - Recording State
    
    fileprivate func updateRecordingState(progress: Float, timeInterval: TimeInterval) {
        v.progressBar.progress = progress
        v.timeElapsedLabel.text = formattedStringFromTimeInterval(timeInterval)
        
        // Animate progress bar changes.
        UIView.animate(withDuration: 1.0, animations: v.progressBar.layoutIfNeeded)
    }
    
    fileprivate func resetRecordingState() {
        v.progressBar.progress = 0.0
        v.timeElapsedLabel.text = formattedStringFromTimeInterval(0)
    }
    
    fileprivate func formattedStringFromTimeInterval(_ timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Focus
    
    fileprivate func focusOnTapPosition(_ position: CGPoint) {
        v.focusView.center = position
        v.addSubview(v.focusView)
        
        // Animate Focus View
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: .curveEaseIn, animations: {
            self.v.focusView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.v.focusView.alpha = 1.0
        }, completion: { _ in
            self.v.focusView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.v.focusView.removeFromSuperview()
        })
    }
    
    // MARK: - UIGestureRecognizer Handling
    
    @objc func handleFocus(_ recognizer: UITapGestureRecognizer) {
        doAfterPermissionCheck {
            let position = recognizer.location(in: self.v.previewContainerView)
            self.focusOnTapPosition(position)
        }
    }
}

// MARK: - CameraViewDelegate

extension VideoViewController: CameraViewDelegate {
    
    func didFlip() {
        videoCaptureManager.flipCamera()
    }
    
    func didFlash() {}
    
    func didShoot() {
        videoCaptureManager.isRecording ? videoCaptureManager.stopRecording() : videoCaptureManager.startRecording()
        
        let shootButtonImage = UIImage(named: videoCaptureManager.isRecording ? "video_recording_start" : "video_recording_stop")?.withRenderingMode(.alwaysOriginal)
        v.shootButton.setImage(shootButtonImage, for: .normal)
    }
}
