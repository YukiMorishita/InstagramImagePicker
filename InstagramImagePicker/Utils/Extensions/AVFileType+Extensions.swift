//
//  AVFileType+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/31.
//  Copyright © 2020 admin. All rights reserved.
//

import AVFoundation
import MobileCoreServices

extension AVFileType {
    /// Fetch and extension for a file from UTI string
    var fileExtension: String {
        if let ext = UTTypeCopyPreferredTagWithClass(self as CFString, kUTTagClassFilenameExtension)?.takeRetainedValue() {
            return ext as String
        }
        return "None"
    }
}
