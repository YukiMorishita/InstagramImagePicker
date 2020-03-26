//
//  Album.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

struct Album {
    var thumbnail: UIImage?
    var title: String = ""
    var numberOfItems: Int = 0
    var collection: PHAssetCollection?
}
