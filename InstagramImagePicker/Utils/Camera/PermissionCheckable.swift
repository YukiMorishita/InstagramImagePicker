//
//  PermissionCheckable.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

protocol PermissionCheckable {
    func checkPermission()
}

extension PermissionCheckable where Self: UIViewController {
    
    // MARK: - AVCaptureDevice Permission
    
    func checkPermission() {
        requestAccessForVideo { (_) in }
    }
    
    func doAfterPermissionCheck(completion: @escaping() -> ()) {
        requestAccessForVideo { (hasPermission) in
            guard hasPermission else { return }
            completion()
        }
    }
    
    func requestAccessForVideo(completion: @escaping(Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                guard granted else { return }
                completion(true)
            }
        @unknown default:
            fatalError()
        }
    }
}

class PermissionDeniedPopup {
    
    func popup(completion: @escaping() -> ()) -> UIAlertController {
        let alert = UIAlertController(title: "Permission denied", message: "Please allow access", preferredStyle: .alert)
        
        let grantPermissionAction = UIAlertAction(title: "Grant Permission", style: .default) { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } else {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            completion()
        }
        
        alert.addAction(grantPermissionAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
