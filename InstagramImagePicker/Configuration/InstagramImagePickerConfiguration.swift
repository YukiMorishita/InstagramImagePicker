//
//  InstagramImagePickerConfiguration.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

// Typealias
internal var Config: InstagramImagePickerConfiguration { return InstagramImagePickerConfiguration.shared }

public struct InstagramImagePickerConfiguration {
    
    public static var shared: InstagramImagePickerConfiguration = InstagramImagePickerConfiguration()
    
    // MARK: Initializer
    
    public init() {}
    
    public var startOnScreen: PickerScreen = .library
    
    public var screens: [PickerScreen] = [.library, .photo, .video]
}
