//
//  VideoView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    
    var player: AVPlayer? {
        get {
            playImageView.image = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer = AVPlayerLayer()
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let playerView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        return view
    }()
    
    let playImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0.8
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupTapGesture()
        
        // Loop play back
        addReachEndObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(previewImageView)
        addSubview(playerView)
        addSubview(playImageView)
        
        playerView.layer.addSublayer(playerLayer)
        
        previewImageView.fillSuperview()
        playerView.fillSuperview()
        playImageView.centerInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = playerView.frame
    }
    
    // MARK: - UITapGestureRecognizer
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSingleTap() {
        pauseUnpause()
    }
    
    // MARK: - Observer
    
    fileprivate func addReachEndObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    fileprivate func removeReachEndObserver() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func handleReachEnd() {
        player?.actionAtItemEnd = .none
        player?.seek(to: .zero)
        player?.play()
    }
}

extension VideoView {
    
    public func setPreviewImage(_ image: UIImage) {
        previewImageView.image = image
    }
    
    public func loadVideo<T>(_ item: T) {
        var player: AVPlayer
        
        switch item.self {
        case let video as Video:
            player = AVPlayer(url: video.videoURL)
        case let url as URL:
            player = AVPlayer(url: url)
        case let playerItem as AVPlayerItem:
            player = AVPlayer(playerItem: playerItem)
        default:
            return
        }
        
        playerLayer.player = player
        playerView.alpha = 1
    }
    
    /// Convenience func to pause or unpause video dependely of state
    public func pauseUnpause() {
        player?.rate == 0.0 ? play() : pause()
    }
    
    public func play() {
        player?.play()
        showPlayImage(isShow: false)
        addReachEndObserver()
    }
    
    public func pause() {
        player?.pause()
        showPlayImage(isShow: true)
    }
    
    public func showPlayImage(isShow: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.playImageView.alpha = isShow ? 0.8 : 0.0
        }
    }
    
    public func deallocate() {
        playerLayer.player = nil
        playImageView.image = nil
    }
}

