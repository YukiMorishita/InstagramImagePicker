//
//  LibraryView.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/05.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol LibraryViewDelegate: class {
    func didSquareCropping()
    func didMultipleSelection()
}

class LibraryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LibraryViewDelegate?
    
    public let assetZoomableViewMinimalVisibleHeight: CGFloat = 50
    public var assetContainerViewTopConstraint: NSLayoutConstraint!
    
    let assetContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let assetZoomableView: AssetZoomableView = {
        let sv = AssetZoomableView()
        return sv
    }()
    
    var squareCroppingButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "square_cropping")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleSquareCropping), for: .touchUpInside)
        return button
    }()
    
    var multipleSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "multiple_selection_off")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleMultipleSelection), for: .touchUpInside)
        return button
    }()
    
    let gridView: GridView = {
        let gv = GridView()
        gv.alpha = 0.0
        return gv
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0.0
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        let spacing: CGFloat = 1 * 3
        let size = (UIScreen.main.bounds.width - spacing) / 4
        layout.itemSize = CGSize(width: size, height: size)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = true
        cv.alwaysBounceVertical = true
        cv.clipsToBounds = true
        return cv
    }()
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(assetContainerView)
        addSubview(separator)
        addSubview(collectionView)
        
        assetContainerView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: UIScreen.main.bounds.width)
        
        assetContainerViewTopConstraint = assetContainerView.topAnchor.constraint(equalTo: topAnchor)
        assetContainerViewTopConstraint.isActive = true
        
        separator.anchor(top: assetContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1.0)
        
        collectionView.anchor(top: separator.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupAssetContainerView()
    }
    
    fileprivate func setupAssetContainerView() {
        assetContainerView.addSubview(assetZoomableView)
        assetContainerView.addSubview(squareCroppingButton)
        assetContainerView.addSubview(multipleSelectionButton)
        assetContainerView.addSubview(gridView)
        assetContainerView.addSubview(overlayView)
        
        assetZoomableView.fillSuperview()
        gridView.fillSuperview()
        overlayView.fillSuperview()
        
        squareCroppingButton.anchor(top: nil, left: assetContainerView.leftAnchor, bottom: assetContainerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: 42, height: 42)
        
        multipleSelectionButton.anchor(top: nil, left: nil, bottom: assetContainerView.bottomAnchor, right: assetContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: 42, height: 42)
    }
    
    // MARK: - Action Handling
    
    @objc func handleSquareCropping() {
        delegate?.didSquareCropping()
    }
    
    @objc func handleMultipleSelection() {
        delegate?.didMultipleSelection()
    }
}
