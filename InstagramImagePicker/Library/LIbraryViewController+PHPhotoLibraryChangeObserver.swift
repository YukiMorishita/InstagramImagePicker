//
//  LIbraryViewController+PHPhotoLibraryChangeObserver.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/05.
//  Copyright © 2020 admin. All rights reserved.
//

import Photos

extension LibraryViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.refreshPhotoLibrary(changeInstance)
        }
    }
    
    private func refreshPhotoLibrary(_ changeInstance: PHChange) {
        guard let fetchResults = self.mediaManager.fetchResult else { return }
        
        guard let changes = changeInstance.changeDetails(for: fetchResults) else { return }
        // Keep the new fetch result for future use.
        mediaManager.fetchResult = changes.fetchResultAfterChanges
        
        guard changes.hasIncrementalChanges else {
            v.collectionView.reloadData()
            mediaManager.resetCachedAssets()
            return
        }
        
        // If there are incremental diffs, animate them in the collection view.
        v.collectionView.performBatchUpdates({
            // For indexes to make sense, updates must be in this order:
            // delete, insert, reload, move
            if let removed = changes.removedIndexes, removed.count > 0 {
                v.collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section: 0) })
            }
            
            if let inserted = changes.insertedIndexes, inserted.count > 0 {
                v.collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section: 0) })
            }
            
            if let changed = changes.changedIndexes, changed.count > 0 {
                v.collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section: 0) })
            }
        }, completion: nil)
        
        // Reset cached assets
        mediaManager.resetCachedAssets()
    }
}
