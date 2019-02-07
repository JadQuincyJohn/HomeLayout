//
//  CollectionViewController.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

class CollectionViewControllerViewModel {
    let data: [Int]
    
    func data(at index: Int) -> String {
        return String(data[index])
    }
    
    init(data: [Int]){
        self.data = data
    }
}

class CollectionViewController: UIViewController {
    
    var viewModel: CollectionViewControllerViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    private func updateUI() {
        collectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.backgroundColor = UIColor(230, 126, 34)
        cell.label.text = viewModel.data(at: indexPath.row)
        cell.label.textColor = UIColor(44, 62, 80)
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
