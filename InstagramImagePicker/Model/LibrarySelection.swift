//
//  LibrarySelection.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

struct LibrarySelection {
    let index: Int
    let assetIdentifier: String
    var cropRect: CGRect?
    var scrollViewContentOffset: CGPoint?
    var scrollViewZoomScale: CGFloat?
    
    init(index: Int, assetIdentifier: String, cropRect: CGRect? = nil, scrollViewContentOffset: CGPoint? = nil, scrollViewZoomScale: CGFloat? = nil) {
        self.index = index
        self.assetIdentifier = assetIdentifier
        self.cropRect = cropRect
        self.scrollViewContentOffset = scrollViewContentOffset
        self.scrollViewZoomScale = scrollViewZoomScale
    }
}
