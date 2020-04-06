//
//  VideoCaptureManager.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class VideoCaptureManager: NSObject {
    
    // MARK: - Properties
    
    public var isRecording: Bool { return videoOutput.isRecording }
    
    private let sessionQueue = DispatchQueue(label: "VideoCaptureManager", qos: .background)
    private let session = AVCaptureSession()
    private var videoInput: AVCaptureDeviceInput!
    private var videoOutput = AVCaptureMovieFileOutput()
    private var previewView: UIView!
    private var videoLayer: AVCaptureVideoPreviewLayer!
    
    private var timer: Timer?
    private var startTime = Date()
    private let videoRecordingTimeLimit = 60.0
    
    public var videoRecordingProgress: ((_ progress: Float, _ timeInterval: TimeInterval) -> Void)?
    
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
    
    public func flipCamera() {
        sessionQueue.async {
            self.flip()
        }
    }
    
    fileprivate func flip() {
        // Remove inputs
        session.inputs.forEach { (input) in
            self.session.removeInput(input)
        }
        
        guard let _videoInput = self.videoInput else { return }
        videoInput = flippedDeviceInputForDeviceInput(_videoInput)
        
        guard let newVideoInput = self.videoInput else { return }
        
        if session.canAddInput(newVideoInput) {
            session.addInput(newVideoInput)
        }
    }
    
    // MARK: - Recording
    
    public func startRecording() {
        let outputURL = VideoGenerator.makeVideoURL(filename: "recordedVideo", isTemporary: true)
        
        checkOrientation { (orientation) in
            if let connection = self.videoOutput.connection(with: .video) {
                
                if let orientation = orientation, connection.isVideoOrientationSupported {
                    connection.videoOrientation = orientation
                }
                
                self.videoOutput.startRecording(to: outputURL, recordingDelegate: self)
            }
        }
    }
    
    public func stopRecording() {
        videoOutput.stopRecording()
    }
    
    fileprivate func checkOrientation(completion: @escaping(AVCaptureVideoOrientation?) -> Void) {
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 1.0
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
            motionManager.stopAccelerometerUpdates()
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let orientation: AVCaptureVideoOrientation = abs(data.acceleration.y) < abs(data.acceleration.x)
            ? data.acceleration.x > 0 ? .landscapeLeft : .landscapeRight
            : data.acceleration.y > 0 ? .portraitUpsideDown : .portrait
            
            DispatchQueue.main.async {
                completion(orientation)
            }
        }
    }
    
    // MARK: - Action Handling
    
    @objc func handleTimeUpdate() {
        let timeElapsed = Date().timeIntervalSince(startTime)
        let progress: Float = Float(timeElapsed) / Float(videoRecordingTimeLimit)
        
        DispatchQueue.main.async {
            self.videoRecordingProgress?(progress, timeElapsed)
        }
    }
}

extension VideoCaptureManager: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimeUpdate), userInfo: nil, repeats: true)
        startTime = Date()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // Stop timer
        timer?.invalidate()
    }
}
