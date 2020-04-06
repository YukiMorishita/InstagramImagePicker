//
//  LibraryMediaManager.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/05.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

class LibraryMediaManager: NSObject {
    
    // MARK: - Properties
    
    public var collection: PHAssetCollection?
    public var fetchResult: PHFetchResult<PHAsset>!
    public let imageManager = PHCachingImageManager()
    
    private var previousPreheatRect: CGRect = .zero
    
    // MARK: - Initializer
    
    override init() {
        super.init()
    }
    
    // MARK: - Cache
    
    public func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    public func updateCachedAssets(in collectionView: UICollectionView) {
        // The preheat window is twice the height of the visible rect.
        var preheatRect: CGRect = collectionView.bounds
        preheatRect = preheatRect.insetBy(dx: 0.0, dy: -0.5 * preheatRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.minY - previousPreheatRect.midY)
        guard delta > collectionView.bounds.height / 3 else { return }
        
        var addedIndexPaths: [IndexPath] = []
        var removedIndexPaths: [IndexPath] = []
        
        // Compute the assets to start caching and to stop caching.
        previousPreheatRect.differenceWith(rect: preheatRect, removedHandler: { (removedRect) in
            let indexPaths = collectionView.aapl_indexPathsForElementsInRect(removedRect)
            removedIndexPaths += indexPaths
        }, addedHandler: { (addedRect) in
            let indexPaths = collectionView.aapl_indexPathsForElementsInRect(addedRect)
            addedIndexPaths += indexPaths
        })
        
        let size = UIScreen.main.bounds.width / 4 * UIScreen.main.scale // cell size
        let targetSize = CGSize(width: size, height: size)
        
        let addedAssets: [PHAsset] = fetchResult.assetsAtIndexPaths(addedIndexPaths)
        let removedAssets: [PHAsset] = fetchResult.assetsAtIndexPaths(removedIndexPaths)
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets, targetSize: targetSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets, targetSize: targetSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
}

extension CGRect {
    
    func differenceWith(rect: CGRect,
                        removedHandler: (CGRect) -> Void,
                        addedHandler: (CGRect) -> Void) {
        if rect.intersects(self) {
            let oldMaxY = self.maxY
            let oldMinY = self.minY
            let newMaxY = rect.maxY
            let newMinY = rect.minY
            if newMaxY > oldMaxY {
                let rectToAdd = CGRect(x: rect.origin.x,
                                       y: oldMaxY,
                                       width: rect.size.width,
                                       height: (newMaxY - oldMaxY))
                addedHandler(rectToAdd)
            }
            if oldMinY > newMinY {
                let rectToAdd = CGRect(x: rect.origin.x,
                                       y: newMinY,
                                       width: rect.size.width,
                                       height: (oldMinY - newMinY))
                addedHandler(rectToAdd)
            }
            if newMaxY < oldMaxY {
                let rectToRemove = CGRect(x: rect.origin.x,
                                          y: newMaxY,
                                          width: rect.size.width,
                                          height: (oldMaxY - newMaxY))
                removedHandler(rectToRemove)
            }
            if oldMinY < newMinY {
                let rectToRemove = CGRect(x: rect.origin.x,
                                          y: oldMinY,
                                          width: rect.size.width,
                                          height: (newMinY - oldMinY))
                removedHandler(rectToRemove)
            }
        } else {
            addedHandler(rect)
            removedHandler(self)
        }
    }
}

extension UICollectionView {
    
    func aapl_indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)
        if (allLayoutAttributes?.count ?? 0) == 0 {return []}
        var indexPaths: [IndexPath] = []
        indexPaths.reserveCapacity(allLayoutAttributes!.count)
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
}

extension PHFetchResult where ObjectType == PHAsset {
    
    func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset] {
        if indexPaths.count == 0 { return [] }
        var assets: [PHAsset] = []
        assets.reserveCapacity(indexPaths.count)
        for indexPath in indexPaths {
            let asset = self[indexPath.item]
            assets.append(asset)
        }
        return assets
    }
}
