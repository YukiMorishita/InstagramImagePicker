//
//  VideoGenerator.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/31.
//  Copyright © 2020 admin. All rights reserved.
//

import AVFoundation

class VideoGenerator: NSObject {
    
    static func makeVideoURL(filename: String, isTemporary: Bool) -> URL {
        let outputURL: URL
        
        if isTemporary {
            let path = NSTemporaryDirectory() + filename + ".\(AVFileType.mov.fileExtension)"
            return URL(fileURLWithPath: path)
        } else {
            guard let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Can't get the documents directory URL")
                return URL(fileURLWithPath: "Error")
            }
            
            outputURL = document.appendingPathComponent(filename + ".\(AVFileType.mov.fileExtension)")
        }
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: outputURL.path) {
            do {
                try fileManager.removeItem(atPath: outputURL.path)
            } catch {
                print("Can't remove the file for some reason.")
            }
        }
        
        return outputURL
    }
}
