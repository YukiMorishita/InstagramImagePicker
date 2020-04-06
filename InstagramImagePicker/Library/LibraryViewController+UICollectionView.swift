//
//  LibraryViewController+UICollectionView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

extension LibraryViewController {
    
    // MARK: - Properties
    
    // Get-only property
    private var maxNumberOfItems: Int { return 5 }
    private var isLimitExceeded: Bool { return selection.count >= maxNumberOfItems }
    
    // MARK: - UICollectionView
    
    public func setupCollectionView() {
        v.collectionView.backgroundColor = .white
        v.collectionView.register(LibraryViewCell.self, forCellWithReuseIdentifier: cellId)
        v.collectionView.dataSource = self
        v.collectionView.delegate = self
    }
    
    public func scrollToTop() {
        v.collectionView.contentOffset = .zero
    }
    
    public func cellSize() -> CGSize {
        let size = UIScreen.main.bounds.width / 4 * UIScreen.main.scale
        return CGSize(width: size, height: size)
    }
    
    fileprivate func formattedStringFromTimeInterval(_ timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Selection
    
    public func addSelection(indexPath: IndexPath) {
        let asset = mediaManager.fetchResult[indexPath.item]
        selection.append(LibrarySelection(index: indexPath.item, assetIdentifier: asset.localIdentifier))
        checkLimit()
    }
    
    public func removeSelection(indexPath: IndexPath) {
        if let index = selection.firstIndex(where: { $0.assetIdentifier == mediaManager.fetchResult[indexPath.item].localIdentifier }) {
            selection.remove(at: index)
            
            // Refresh the numbers
            var selectedIndexPaths = [IndexPath]()
            mediaManager.fetchResult.enumerateObjects { [unowned self] (asset, index, _) in
                if self.selection.contains(where: { $0.assetIdentifier == asset.localIdentifier }) {
                    selectedIndexPaths.append(IndexPath(item: index, section: 0))
                }
            }
            
            v.collectionView.reloadItems(at: selectedIndexPaths)
            
            // Replace the current selected image with the previously selected one
            if let previouslySelectedIndexPath = selectedIndexPaths.last {
                v.collectionView.deselectItem(at: indexPath, animated: false)
                v.collectionView.selectItem(at: previouslySelectedIndexPath, animated: false, scrollPosition: [])
                currentlySelectedIndex = previouslySelectedIndexPath.item
                refreshAsset(mediaManager.fetchResult[previouslySelectedIndexPath.item])
            }
            
            checkLimit()
        }
    }
    
    fileprivate func isSelectioned(indexPath: IndexPath) -> Bool {
        let asset = mediaManager.fetchResult[indexPath.item]
        return selection.contains(where: { $0.assetIdentifier == asset.localIdentifier })
    }
    
    public func checkLimit() {
        //v.maxNumberWarningView.isHidden = !isLimitExceeded || isMultipleSelection == false
        
        // Show or Hide BottomTabBar
        //didChangeMultipleSelectionState?(isLimitExceeded)
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaManager.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LibraryViewCell
        
        let asset = mediaManager.fetchResult[indexPath.item]
        cell.representedAssetIdentifier = asset.localIdentifier
                
        // Set thumbnail image
        mediaManager.imageManager.requestImage(for: asset, targetSize: cellSize(), contentMode: .aspectFill, options: nil) { (image, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
                cell.thumbnail = image
            }
        }
        
        let isVideo = asset.mediaType == .video
        cell.durationLabel.isHidden = !isVideo
        cell.durationLabel.text = isVideo ? formattedStringFromTimeInterval(asset.duration) : ""
        //cell.multipleselectionIndicator.isHidden = !isMultipleSelection
        //cell.isSelected = currentlySelectedIndex == indexPath.item
        
        // Set selection number
        if let index = selection.firstIndex(where: { $0.assetIdentifier == asset.localIdentifier }) {
            cell.multipleselectionIndicator.setNumber(index + 1)
        } else {
            cell.multipleselectionIndicator.setNumber(nil)
        }
        
        return cell
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previouslySelectedIndexPath = IndexPath(item: currentlySelectedIndex, section: 0)
        currentlySelectedIndex = indexPath.item
        
        let asset = mediaManager.fetchResult[indexPath.item]
        refreshAsset(asset)
        
        if isMultipleSelection {
            if isSelectioned(indexPath: indexPath) {
                removeSelection(indexPath: indexPath)
            } else if !isLimitExceeded {
                addSelection(indexPath: indexPath)
            }
            
            collectionView.reloadItems(at: [indexPath])
            collectionView.reloadItems(at: [previouslySelectedIndexPath])
        } else {
            selection.removeAll()
            addSelection(indexPath: indexPath)
            
            guard let previousCell = collectionView.cellForItem(at: previouslySelectedIndexPath) else { return }
            previousCell.isSelected = false
        }
    }
}
