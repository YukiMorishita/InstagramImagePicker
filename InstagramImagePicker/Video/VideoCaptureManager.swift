//
//  VideoCaptureManager.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureManager: NSObject {
    
    // MARK: - Properties
    
    private let sessionQueue = DispatchQueue(label: "VideoCaptureManager", qos: .background)
    private let session = AVCaptureSession()
    private var videoInput: AVCaptureDeviceInput!
    private var videoOutput = AVCaptureMovieFileOutput()
    private var previewView: UIView!
    private var videoLayer: AVCaptureVideoPreviewLayer!
    
    private var timer: Timer?
    private var startTime = Date()
    private let videoRecordingTimeLimit = 60.0
    
    
    // MARK: - Setup
    
    fileprivate func setupCaptureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard let device = deviceForPosition(.back) else { return }
        
        do {
            videoInput = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            // Add audio recoding
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: .audio, position: .unspecified)
            for device in discoverySession.devices {
                if let audioInput = try? AVCaptureDeviceInput(device: device) {
                    if session.canAddInput(audioInput) {
                        session.addInput(audioInput)
                    }
                }
            }
            
            // FPS
            let timeScale: Int32 = 30
            let duration = CMTimeMakeWithSeconds(self.videoRecordingTimeLimit, preferredTimescale: timeScale)
            videoOutput.maxRecordedDuration = duration
            videoOutput.minFreeDiskSpaceLimit = 1024 * 1024
            
            // Allows audio for MP4s over 10 seconds.
            videoOutput.movieFragmentInterval = .invalid
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            session.commitConfiguration()
        } catch let error {
            print("Couldn't not setup camera input:", error)
        }
    }
    
    fileprivate func setupPreviewView() {
        videoLayer = AVCaptureVideoPreviewLayer(session: session)
        
        DispatchQueue.main.async {
            self.videoLayer.frame = self.previewView.bounds
            self.videoLayer.videoGravity = .resizeAspectFill
            self.previewView.layer.addSublayer(self.videoLayer)
        }
    }
    
    // MARK: - Camera
    
    public func startCamera(with previewView: UIView, completion: @escaping() -> Void) {
        self.previewView = previewView
        
        guard !session.isRunning else { return }
        sessionQueue.async { [weak self] in
            self?.session.sessionPreset = .high
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self?.setupCaptureSession()
                self?.setupPreviewView()
                self?.session.startRunning()
                completion()
            case .denied, .notDetermined, .restricted:
                self?.session.stopRunning()
            @unknown default:
                fatalError()
            }
        }
    }
    
    public func stopCamera() {
        guard session.isRunning else { return }
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }
}
