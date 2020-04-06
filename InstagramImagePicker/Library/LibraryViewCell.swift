//
//  LibraryViewCell.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class LibraryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var representedAssetIdentifier: String?
    
    public var thumbnail: UIImage? {
        didSet {
            guard let image = thumbnail else { return }
            thumbnailImageView.image = image
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    let selectionOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.0
        return view
    }()
    
    let multipleselectionIndicator: MultipleSelectionIndicator = {
        let indicator = MultipleSelectionIndicator()
        return indicator
    }()
    
    override var isSelected: Bool {
        didSet { self.refreshSelection() }
    }
    
    override var isHighlighted: Bool {
        didSet { self.refreshSelection() }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Reset properties to default values
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(durationLabel)
        addSubview(selectionOverlayView)
        addSubview(multipleselectionIndicator)
        
        thumbnailImageView.fillSuperview()
        selectionOverlayView.fillSuperview()
        
        durationLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
        multipleselectionIndicator.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 3, width: 0, height: 0)
    }
    
    // MARK: - Selection
    
    fileprivate func refreshSelection() {
        let showOverlay = isSelected || isHighlighted
        selectionOverlayView.alpha = showOverlay ? 0.6 : 0.0
    }
}
