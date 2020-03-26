//
//  InstagramImagePickerViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class InstagramImagePickerViewController: BottomNavigation {
    
    enum PickerMode {
        case library
        case camera
        case video
    }
    
    // MARK: - Properties
    
    private var pickerMode: PickerMode = .library
    
    private var libraryVc: LibraryViewController?
    private var cameraVc: CameraViewController?
    private var videoVc: VideoViewController?
    
    // MARK: - Initializer
    
    /// Set default configuration
    convenience init() {
        self.init(configuration: InstagramImagePickerConfiguration.shared)
    }
    
    /// Set specified configuration
    required init(configuration: InstagramImagePickerConfiguration) {
        InstagramImagePickerConfiguration.shared = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        delegate = self
        
        setup()
        setupNavigationItems()
    }
    
    deinit {
        print("InstagramImagePickerViewController -> deinit")
    }
    
    // MARK: - Setup
    
    fileprivate func setup() {
        // view controllers to display on the screen
        var vcs: [UIViewController] = []
        
        // Set screens
        Config.screens.forEach { (screen) in
            switch screen {
            case .library:
                libraryVc = LibraryViewController()
                libraryVc?.title = "Library"
                libraryVc?.view.backgroundColor = .red
                vcs.append(libraryVc!)
            case .photo:
                cameraVc = CameraViewController()
                cameraVc?.title = "Photo"
                cameraVc?.view.backgroundColor = .blue
                vcs.append(cameraVc!)
            case .video:
                videoVc = VideoViewController()
                videoVc?.title = "Video"
                videoVc?.view.backgroundColor = .yellow
                vcs.append(videoVc!)
            }
        }
        
        controllers = vcs
        
        if let index = Config.screens.firstIndex(of: Config.startOnScreen) {
            startOnPage(index)
        }
        
        updatePickerMode(currentController)
        updateNavgationItems()
        startCurerntViewController()
    }
    
    fileprivate func setupNavigationItems() {
        setupLeftNavItem()
    }
    
    fileprivate func setupLeftNavItem() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    fileprivate func setupRightNavItem() {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
        nextButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = nextButton
    }
    
    fileprivate func setupTitleView(with title: String) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let textLabel = UILabel()
        textLabel.text = title
        textLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        if let navBarTitleFont = UINavigationBar.appearance().titleTextAttributes?[.font] as? UIFont {
            textLabel.font = navBarTitleFont
        }
        
        if let navBarTitleColor = UINavigationBar.appearance().titleTextAttributes?[.foregroundColor] as? UIColor {
            textLabel.textColor = navBarTitleColor
        }
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow_down")
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.clipsToBounds = true
        
        let attributes = UINavigationBar.appearance().titleTextAttributes
        
        if let attributes = attributes, let foregroundColor = attributes[.foregroundColor] as? UIColor {
            arrowImageView.image = #imageLiteral(resourceName: "yp_arrow_down").withRenderingMode(.alwaysOriginal)
            arrowImageView.tintColor = foregroundColor
        }
        
        let button = UIButton()
        button.setBackgroundColor(UIColor.white.withAlphaComponent(0.5))
        button.addTarget(self, action: #selector(handleAlbums), for: .touchUpInside)
        
        titleView.addSubview(textLabel)
        titleView.addSubview(arrowImageView)
        titleView.addSubview(button)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleView.leftAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        arrowImageView.anchor(top: nil, left: textLabel.rightAnchor, bottom: nil, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 14, height: 14)
        arrowImageView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
        
        button.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        navigationItem.titleView = titleView
    }
    
    // MARK: - Update
    
    fileprivate func updatePickerMode(_ vc: UIViewController) {
        switch vc {
        case is LibraryViewController:
            pickerMode = .library
        case is CameraViewController:
            pickerMode = .camera
        case is VideoViewController:
            pickerMode = .video
        default:
            pickerMode = .library
        }
    }
    
    fileprivate func updateNavgationItems() {
        switch pickerMode {
        case .library:
            setupTitleView(with: "Library")
            setupRightNavItem()
        case .camera:
            navigationItem.title = "Photo"
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = nil
        case .video:
            navigationItem.title = "Video"
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - Camera
    
    fileprivate func startCurerntViewController() {
        switch pickerMode {
        case .library:
            libraryVc?.checkPermission()
        case .camera:
            cameraVc?.startCamera()
        case .video:
            videoVc?.startCamera()
        }
    }
    
    fileprivate func stopCurrentCamera() {
        switch pickerMode {
        case .library:
            //libraryViewController?.pausePreview()
            ()
        case .camera:
            cameraVc?.stopCamera()
        case .video:
            videoVc?.stopCamera()
        }
    }
    
    // MARK: - Action Handling
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        
    }
    
    @objc func handleAlbums() {
        let albumsVC = AlbumsViewController()
        let navVC = UINavigationController(rootViewController: albumsVC)
        navVC.navigationBar.tintColor = .black
        navVC.navigationBar.isTranslucent = false
        
        // closure callback
        albumsVC.didSelectAlbum = { [weak self] (album) in
            self?.setupTitleView(with: album.title)
            navVC.dismiss(animated: true, completion: nil)
        }
        
        present(navVC, animated: true, completion: nil)
    }
}

// MARK: - BottomNavigationDelegate

extension InstagramImagePickerViewController: BottomNavigationDelegate {
    
    func didSelect(for vc: UIViewController) {
        stopCurrentCamera()
        updatePickerMode(vc)
        updateNavgationItems()
        startCurerntViewController()
    }
}
