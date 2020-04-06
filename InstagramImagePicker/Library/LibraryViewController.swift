//
//  LibraryViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

class LibraryViewController: UIViewController {
    
    // MARK: - Properties
    
    public var isMultipleSelection: Bool = false
    
    public let mediaManager = LibraryMediaManager()
    public let cellId = "cellId"
    public var selection: [LibrarySelection] = []
    public var currentlySelectedIndex: Int = 0
    
    public let v = LibraryView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.delegate = self
        
        setup()
    }
    
    deinit {
        print("LibraryViewController -> deinit")
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - Setup
    
    fileprivate func setup() {
        setupCollectionView()
        mediaManager.resetCachedAssets()
        refreshMedia()
        PHPhotoLibrary.shared().register(self)
    }
    
    // MARK: - Album
    
    public func setAlbum(_ album: Album) {
        title = album.title
        
        // Refresh selected photos
        mediaManager.collection = album.collection
        refreshMedia()
    }
    
    // MARK: - Media
    
    fileprivate func refreshMedia() {
        let fetchOptions = buildPHFetchOptions()
        
        if let collection = mediaManager.collection {
            mediaManager.fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        } else {
            mediaManager.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        }
        
        guard mediaManager.fetchResult.count > 0 else {
            return
        }
        
        let asset = mediaManager.fetchResult[0]
        refreshAsset(asset)
        
        v.collectionView.reloadData()
        v.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        scrollToTop()
    }
    
    public func refreshAsset(_ asset: PHAsset) {
        DispatchQueue.global(qos: .userInitiated).async {
            switch asset.mediaType {
            case .image:
                ()
            case .video:
                ()
            case .audio, .unknown:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    // MARK: - PHFetchOptions
    
    fileprivate func buildPHFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }
    
    // MARK: - Cropping
    
    // MARK: - Multiple Selection
    
    // MARK: - Permission
    
    public func checkPermission() {
        requestAccessForPhotoLibrary { (hasPermission) in
            if hasPermission {
                self.setup()
            }
        }
    }
    
    public func doAfterPermissionCheck(completion: @escaping() -> Void) {
        requestAccessForPhotoLibrary { (hasPermission) in
            if hasPermission {
                completion()
            }
        }
    }
    
    fileprivate func requestAccessForPhotoLibrary(completion: @escaping(Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .restricted, .denied:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async { completion(status == .authorized) }
            }
        default:
            fatalError()
        }
    }
}

// MARK: - LibraryViewDelegate

extension LibraryViewController: LibraryViewDelegate {
    
    func didSquareCropping() {
        
    }
    
    func didMultipleSelection() {
        doAfterPermissionCheck {
            
        }
        
        isMultipleSelection = !isMultipleSelection
        
        let image = UIImage(named: isMultipleSelection ? "multiple_selection_on" : "multiple_selection_off")?.withRenderingMode(.alwaysOriginal)
        v.multipleSelectionButton.setImage(image, for: .normal)
    }
}
