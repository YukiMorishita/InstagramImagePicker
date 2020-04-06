//
//  MediaItem.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

enum MediaItem {
    case photo(_ photo: Photo)
    case video(_ video: Video)
}

struct Photo {
    var image: UIImage { return editedImage ?? originalImage }
    let asset: PHAsset?
    let originalImage: UIImage
    var editedImage: UIImage?
    
    init(asset: PHAsset? = nil, image: UIImage) {
        self.asset = asset
        self.originalImage = image
        self.editedImage = nil
    }
}

struct Video {
    let asset: PHAsset?
    let thumbnail: UIImage
    let videoURL: URL
    
    init(asset: PHAsset? = nil, thumbnail: UIImage, videoURL: URL) {
        self.asset = asset
        self.thumbnail = thumbnail
        self.videoURL = videoURL
    }
}
