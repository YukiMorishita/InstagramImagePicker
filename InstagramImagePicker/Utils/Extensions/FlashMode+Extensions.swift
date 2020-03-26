//
//  FlashMode+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

extension AVCaptureDevice.FlashMode {
    
    func flashImage() -> UIImage {
        switch self {
        case .auto:
            return UIImage(named: "flash_auto")!.withRenderingMode(.alwaysOriginal)
        case .on:
            return UIImage(named: "flash_on")!.withRenderingMode(.alwaysOriginal)
        case .off:
            return UIImage(named: "flash_off")!.withRenderingMode(.alwaysOriginal)
        @unknown default:
            fatalError()
        }
    }
}
