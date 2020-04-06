//
//  AssetZoomableView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Photos

protocol AssetZoomableViewDelegate: class {
    func scrollViewWillBeginDragging()
    func scrollViewDidEndDragging()
    func scrollViewDidZoom()
    func scrollViewDidEndZooming()
}

class AssetZoomableView: UIScrollView {
    
    // MARK: Properties
    
    weak var myDelegate: AssetZoomableViewDelegate?
    
    public var didShowSquareCropButton: ((Bool) -> Void)?
    
    private var isVideoMode = false
    private var currentAsset: PHAsset?
    
    public var squaredZoomScale: CGFloat = 1.0
    public var mediaManager: LibraryMediaManager?
    
    public var assetImageView: UIImageView {
        return isVideoMode ? videoView.previewImageView : photoImageView
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let videoView: VideoView = {
        let vv = VideoView()
        return vv
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupScrollView() {
        backgroundColor = .white
        maximumZoomScale = 6.0
        minimumZoomScale = 1.0
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        isScrollEnabled = true
        clipsToBounds = true
        delegate = self
    }
    
    // MARK: - Public Method
    
    public func setImage(_ photo: PHAsset, completion: @escaping(Bool) -> Void) {
        if currentAsset == photo {
            DispatchQueue.main.async { completion(false) }
            return
        }
        
        currentAsset = photo
        
        mediaManager?.imageManager.fetchImage(for: photo, completion: { (image, isDegrade) in

            if !self.photoImageView.isDescendant(of: self) {
                self.isVideoMode = false
                self.videoView.removeFromSuperview()
                self.videoView.showPlayImage(isShow: false)
                self.videoView.deallocate()
                self.addSubview(self.photoImageView)
            }

            self.photoImageView.image = image

            self.setAssetFrame(for: self.photoImageView, image: image)

            completion(isDegrade)
        })
    }
    
    public func setVideo(_ video: PHAsset, completion: @escaping() -> Void) {
        mediaManager?.imageManager.fetchPreview(for: video, completion: { (image) in
            
            if !self.videoView.isDescendant(of: self) {
                self.isVideoMode = true
                self.photoImageView.removeFromSuperview()
                self.addSubview(self.videoView)
            }
            
            self.videoView.setPreviewImage(image)
            
            self.setAssetFrame(for: self.videoView, image: image)
            
            completion()
        })
        
        mediaManager?.imageManager.fetchPlayerItem(for: video, callback: { [weak self] (playerItem) in
            guard let strongSelf = self else { return }

            guard strongSelf.currentAsset != video else {
                completion()
                return
            }
            
            strongSelf.currentAsset = video
            
            strongSelf.videoView.loadVideo(playerItem)
            strongSelf.videoView.play()
        })
    }
    
    fileprivate func setAssetFrame(for view: UIView, image: UIImage) {
        // Reseting the previous scale
        self.minimumZoomScale = 1.0
        self.zoomScale = 1.0
        
        let screenWidth = UIScreen.main.bounds.width
        
        let w = image.size.width
        let h = image.size.height
        
        var aspectRatio: CGFloat = 1.0
        
        if h > w {
            // Portrait
            aspectRatio = w / h
            view.frame.size.width = screenWidth * aspectRatio
            view.frame.size.height = screenWidth
            self.didShowSquareCropButton?(false)
        } else if w > h {
            // Landscape
            aspectRatio = h / w
            view.frame.size.width = screenWidth
            view.frame.size.height = screenWidth * aspectRatio
            self.didShowSquareCropButton?(false)
        } else {
            // Square
            view.frame.size.width = screenWidth
            view.frame.size.height = screenWidth
            self.didShowSquareCropButton?(true)
        }
        
        view.center = self.center
    }
    
    fileprivate func centerAssetView() {
        let assetView = isVideoMode ? videoView : photoImageView
        let scrollViewBoundsSize = self.bounds.size
        var assetFrame = assetView.frame
        let assetSize = assetView.frame.size
        
        assetFrame.origin.x = (assetSize.width < scrollViewBoundsSize.width) ?
            (scrollViewBoundsSize.width - assetSize.width) / 2.0 : 0
        assetFrame.origin.y = (assetSize.height < scrollViewBoundsSize.height) ?
            (scrollViewBoundsSize.height - assetSize.height) / 2.0 : 0.0
        
        assetView.frame = assetFrame
    }
    
    public func fitImage(_ fit: Bool, animated: Bool = false) {
        squaredZoomScale = calculateSquaredZoomScale()
        if fit {
            setZoomScale(squaredZoomScale, animated: animated)
        } else {
            setZoomScale(1.0, animated: animated)
        }
    }
    
    // Calculate zoom scale which will fit the image to square
    fileprivate func calculateSquaredZoomScale() -> CGFloat {
        guard let image = assetImageView.image else {
            return 1.0
        }
        
        var squareZoomScale: CGFloat = 1.0
        let w = image.size.width
        let h = image.size.height
        
        // Portrait
        if h > w {
            squareZoomScale = (h / w)
        }
        
        // Landscape
        if w > h {
            squareZoomScale = (w / h)
        }
        
        return squareZoomScale
    }
}

extension AssetZoomableView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return isVideoMode ? videoView : photoImageView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        myDelegate?.scrollViewWillBeginDragging()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        myDelegate?.scrollViewDidEndDragging()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        myDelegate?.scrollViewDidZoom()
        centerAssetView()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        myDelegate?.scrollViewDidEndZooming()
    }
}
