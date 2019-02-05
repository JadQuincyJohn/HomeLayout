//
//  ImagesViewController.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 05/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

struct ImagesViewControllerViewModel {
    
    let artist: Int
    let service: APIService

    var images: [URL] = [] {
        didSet {
            dataChangedClosure?()
        }
    }
    
    var dataChangedClosure: (() -> ())?
    
    func imageURL(at index: Int) -> URL {
        return images[index]
    }
    
    init(artist: Int, service: APIService) {
        self.service = service
        self.artist = artist
    }
}

class ImagesViewController: UIViewController {
    
    var viewModel: ImagesViewControllerViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.hidesWhenStopped = true
        
        viewModel.dataChangedClosure = {
            self.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performFetch()
    }
    
    func performFetch() {
        activityIndicatorView.startAnimating()
        viewModel.service.getAlbums(with: viewModel.artist, limit: 100) { response, error in
            DispatchQueue.main.async {
                self.viewModel.images = response?.albums.map { $0.cover_medium } ?? []
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let url = viewModel.imageURL(at: indexPath.row)
        cell.customImageView.cacheImage(urlString: url.absoluteString)
        return cell
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.height, height: view.bounds.height)
    }
}
