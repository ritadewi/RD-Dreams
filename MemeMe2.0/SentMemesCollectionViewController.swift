//
//  SentMemesCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Rita Dewi on 14/11/2018.
//  Copyright © 2018 RitaDewi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memesInCollectionView = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2*space))/3
        let heightdimension = (view.frame.size.height - (2*space))/6
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: heightdimension)
        self.view.layer.borderColor = UIColor.black.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memesInCollectionView = appDelegate.memes
        collectionView?.reloadData()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesInCollectionView.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let memesItem = self.memesInCollectionView[(indexPath as NSIndexPath).row]
        
        cell.memedImage?.image = memesItem.memedImage

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memesInDetailView = memesInCollectionView[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
        return true
    }
}
