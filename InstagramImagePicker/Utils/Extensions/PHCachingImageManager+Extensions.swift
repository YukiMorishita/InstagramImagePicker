//
//  PHCachingImageManager+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

extension PHCachingImageManager {
    
    /// This method return two images in the callback. First is with low resolution, second with high.
    /// So the callback fires twice.
    func fetchImage(for asset: PHAsset, completion: @escaping(UIImage, Bool) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (image, info) in
            
            guard let image = image else {
                print("Failed to fetch image.")
                return
            }
            
            DispatchQueue.main.async {
                let isDegrade = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                completion(image, isDegrade)
            }
        }
    }
    
    func fetchPreview(for video: PHAsset, completion: @escaping(UIImage) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        
        let screenWidth = UIScreen.main.bounds.width
        let targetSize = CGSize(width: screenWidth, height: screenWidth)
        
        requestImage(for: video, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
            
            guard let image = image else {
                print("Failed to fetch preview")
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func fetchPlayerItem(for video: PHAsset, callback: @escaping(AVPlayerItem) -> ()) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        
        requestPlayerItem(forVideo: video, options: options) { (playerItem, _) in
            if let playerItem = playerItem {
                DispatchQueue.main.async {
                    callback(playerItem)
                }
            }
        }
    }
}
