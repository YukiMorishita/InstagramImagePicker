//
//  AVFoundation+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import AVFoundation

public func deviceForPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    
    for device in discoverySession.devices where device.position == position {
        return device
    }
    return nil
}

public func flippedDeviceInputForDeviceInput(_ deviceInput: AVCaptureDeviceInput) -> AVCaptureDeviceInput? {
    let position = flippedPositionForDevice(deviceInput.device)
    if let device = deviceForPosition(position) {
        return try? AVCaptureDeviceInput(device: device)
    }
    return nil
}

public func flippedPositionForDevice(_ device: AVCaptureDevice) -> AVCaptureDevice.Position {
    return (device.position == .front) ? .back : .front
}
