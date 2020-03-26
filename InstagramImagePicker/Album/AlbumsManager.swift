//
//  AlbumsManager.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

class AlbumsManager {
    
    private var cachedAlbums: [Album]?
    
    public func fetchAlbums() -> [Album] {
        if let cachedAlbums = cachedAlbums {
            return cachedAlbums
        }
        
        var albums = [Album]()
        let options = PHFetchOptions()
        
        let smartAlbumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        
        for result in [smartAlbumResult, albumResult] {
            result.enumerateObjects { (assetCollection, _, _) in
                var album = Album()
                album.title = assetCollection.localizedTitle ?? ""
                album.numberOfItems = self.mediaCount(collection: assetCollection)
                
                // Fetch thumbnail image
                if album.numberOfItems > 0 {
                    let fetchResults = PHAsset.fetchKeyAssets(in: assetCollection, options: nil)
                    if let firstAsset = fetchResults?.firstObject {
                        let deviceScale = UIScreen.main.scale
                        let thumbnailSize: CGFloat = 78.0
                        let targetSize = CGSize(width: thumbnailSize * deviceScale, height: thumbnailSize * deviceScale)
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        options.deliveryMode = .opportunistic
                        PHImageManager.default().requestImage(for: firstAsset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
                            album.thumbnail = image
                        }
                    }
                    album.collection = assetCollection
                    
                    if !(assetCollection.assetCollectionSubtype == .smartAlbumSlomoVideos || assetCollection.assetCollectionSubtype == .smartAlbumVideos) {
                        albums.append(album)
                    }
                    
                    if assetCollection.assetCollectionSubtype == .smartAlbumAllHidden {
                        albums.removeLast()
                    }
                }
            }
        }
        cachedAlbums = albums
        return albums
    }
    
    private func mediaCount(collection: PHAssetCollection) -> Int {
        let options = PHFetchOptions()
        let result = PHAsset.fetchAssets(in: collection, options: options)
        return result.count
    }
}

