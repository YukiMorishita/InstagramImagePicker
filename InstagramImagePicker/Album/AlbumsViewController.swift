//
//  AlbumsViewController.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/25.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    // MARK: - Properties
    
    public var didSelectAlbum: ((Album) -> Void)?
    
    private let albumsManager = AlbumsManager()
    private var albums: [Album] = []
    
    private let cellId = "cellId"
    
    private let v = AlbumsView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItems()
        fetchAlbums()
    }
    
    // MARK: - Setup
    
    fileprivate func setupTableView() {
        v.tableView.register(AlbumCell.self, forCellReuseIdentifier: cellId)
        v.tableView.dataSource = self
        v.tableView.delegate = self
    }
    
    fileprivate func setupNavigationItems() {
        setupRemainigNavItem()
        setupLeftNavItem()
    }
    
    fileprivate func setupRemainigNavItem() {
        navigationItem.title = "Albums"
    }
    
    fileprivate func setupLeftNavItem() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: - Fetcher
    
    fileprivate func fetchAlbums() {
        v.activityIndicatorView.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.albums = self.albumsManager.fetchAlbums()
            
            DispatchQueue.main.async {
                self.v.activityIndicatorView.stopAnimating()
                self.v.tableView.isHidden = false
                self.v.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Action Handling
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AlbumCell
        
        let album = albums[indexPath.row]
        cell.album = album
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        didSelectAlbum?(album)
    }
}
