//
//  PhotoCaptureManager.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCaptureManager: NSObject {
    
    // MARK: - Properties
    
    private let sessionQueue = DispatchQueue(label: "PhotoCaptureManager", qos: .background)
    private let session = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()
    private var previewView: UIView!
    private var videoLayer: AVCaptureVideoPreviewLayer!
    
    public var capturedPhoto: ((Data) -> Void)?
    public var currentFlashMode: AVCaptureDevice.FlashMode = .off
    
    // MARK: - Setup
    
    fileprivate func setupCaptureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        // Simulator == nil
        guard let device = deviceForPosition(.back) else { return }
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
            
            guard let videoInput = deviceInput else { return }
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                photoOutput.isHighResolutionCaptureEnabled = true
                photoOutput.setPreparedPhotoSettingsArray([buildCapturePhotoSettings()], completionHandler: nil)
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
    
    fileprivate func buildCapturePhotoSettings() -> AVCapturePhotoSettings {
        let settings: AVCapturePhotoSettings
        
        // Catpure Heif when available.
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            settings = AVCapturePhotoSettings()
        }
        
        // Catpure Highest Quality possible.
        //settings.isHighResolutionPhotoEnabled = true
        settings.isHighResolutionPhotoEnabled = true
        
        // Set flash mode.
        if let videoInput = deviceInput {
            if videoInput.device.isFlashAvailable {
                switch currentFlashMode {
                case .off:
                    if photoOutput.supportedFlashModes.contains(.off) {
                        settings.flashMode = .off
                    }
                case .on:
                    if photoOutput.supportedFlashModes.contains(.on) {
                        settings.flashMode = .on
                    }
                case .auto:
                    if photoOutput.supportedFlashModes.contains(.auto) {
                        settings.flashMode = .auto
                    }
                @unknown default:
                    fatalError()
                }
            }
        }
        
        return settings
    }
    
    // MARK: - Camera
    
    public func startCamera(with previewView: UIView, completion: @escaping() -> Void) {
        self.previewView = previewView
        
        guard !session.isRunning else { return }
        sessionQueue.async { [weak self] in
            self?.session.sessionPreset = .photo
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
    
    public func flipCamera() {
        sessionQueue.async {
            self.flip()
        }
    }
    
    private func flip() {
        // Reset inputs
        session.inputs.forEach { (input) in
            self.session.removeInput(input)
        }
        
        guard let _deviceInput = deviceInput else { return }
        deviceInput = flippedDeviceInputForDeviceInput(_deviceInput)
        
        guard let videoInput = deviceInput else { return }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
    }
    
    public func shoot(completion: @escaping(Data) -> Void) {
        // Do not execute camera capture for simulator
        #if (!arch(x86_64))
        
        capturedPhoto = completion
    
        let setting = buildCapturePhotoSettings()
        photoOutput.capturePhoto(with: setting, delegate: self)
        
        #endif
    }
    
    func isDevicePositionToFront() -> Bool {
        return deviceInput?.device.position == .front ? true : false
    }
    
    // MARK: - Flash
    
    public func updateFlashMode() {
        switch currentFlashMode {
        case .auto:
            currentFlashMode = .on
        case .on:
            currentFlashMode = .off
        case .off:
            currentFlashMode = .auto
        @unknown default:
            fatalError()
        }
    }
}

extension PhotoCaptureManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Failed to take photo:", error)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        capturedPhoto?(imageData)
    }
}
