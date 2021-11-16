//
//  ImageViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 16/11/2021.
//

import Foundation
import UIKit
import Photos

class ImageViewController: UICollectionViewController {
    
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populatePhotos()
    }
    private func setupUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollection", for: indexPath) as? ImagesCollection
        else {
            fatalError("Not found")
        }
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.imageCollectionView.image = image
            }
        }
        return cell
    }
    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects{ (objects,_,_) in
                    self?.images.append(objects)
                }
                self?.images.reverse()
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

